// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';

import 'llm_provider_interface.dart';

/// A provider class for interacting with Firebase Vertex AI's language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using Firebase Vertex AI's generative model.
class VertexProvider extends LlmProvider {
  /// Creates a new instance of [VertexProvider].
  ///
  /// [model] is the name of the Gemini AI model to use. [apiKey] is the API key
  /// for authentication with the Gemini AI service. [config] is an optional
  /// [GenerationConfig] to customize the text generation.
  VertexProvider({
    GenerativeModel? chatModel,
    GenerativeModel? embeddingModel,
  })  : _embeddingModel = embeddingModel,
        _chat = chatModel?.startChat();

  final GenerativeModel? _embeddingModel;
  final ChatSession? _chat;

  @override
  Future<List<double>> getDocumentEmbedding(String document) =>
      _getEmbedding(document, TaskType.retrievalDocument);

  @override
  Future<List<double>> getQueryEmbedding(String query) =>
      _getEmbedding(query, TaskType.retrievalQuery);

  Future<List<double>> _getEmbedding(String s, TaskType embeddingTask) async {
    if (_embeddingModel == null) {
      throw Exception('embeddingModel is not initialized');
    }

    assert(embeddingTask == TaskType.retrievalDocument ||
        embeddingTask == TaskType.retrievalQuery);

    final content = Content.text(s);
    final result = await _embeddingModel.embedContent(
      content,
      taskType: embeddingTask,
    );

    return result.embedding.values;
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (_chat == null) throw Exception('chatModel is not initialized');

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

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FileData(a.mimeType, a.url.toString()),
      };
}
