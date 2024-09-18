// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_provider_interface.dart';

/// A provider class for interacting with Google's Gemini AI language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using the Gemini AI model.
class GeminiProvider extends LlmProvider {
  /// Creates a new instance of [GeminiProvider].
  ///
  /// [model] is the name of the Gemini AI model to use. [apiKey] is the API key
  /// for authentication with the Gemini AI service. [config] is an optional
  /// [GenerationConfig] to customize the text generation.
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    GenerationConfig? config,
  }) : _embeddingModel = GenerativeModel(
          model: 'text-embedding-004',
          apiKey: apiKey,
        ) {
    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: config,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat();
  }

  late final ChatSession _chat;
  final GenerativeModel _embeddingModel;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
    final response = _chat.sendMessageStream(content);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null) yield text;
    }
  }

  @override
  Future<List<double>> getDocumentEmbedding(String document) =>
      _getEmbedding(document, TaskType.retrievalDocument);

  @override
  Future<List<double>> getQueryEmbedding(String query) =>
      _getEmbedding(query, TaskType.retrievalQuery);

  Future<List<double>> _getEmbedding(String s, TaskType embeddingTask) async {
    assert(embeddingTask == TaskType.retrievalDocument ||
        embeddingTask == TaskType.retrievalQuery);

    final content = Content.text(s);
    final result = await _embeddingModel.embedContent(
      content,
      taskType: embeddingTask,
    );

    return result.embedding.values;
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}
