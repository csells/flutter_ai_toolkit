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
  /// [generativeModel] is an optional [GenerativeModel] instance for text
  /// generation. If provided, it will be used for chat-based interactions and
  /// text generation.
  ///
  /// [embeddingModel] is an optional [GenerativeModel] instance for creating
  /// embeddings. If provided, it will be used for document and query embedding
  /// operations.
  VertexProvider({
    GenerativeModel? generativeModel,
    GenerativeModel? embeddingModel,
  })  : _generativeModel = generativeModel,
        _embeddingModel = embeddingModel,
        _chat = generativeModel?.startChat();

  final GenerativeModel? _generativeModel;
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

    // waiting for: https://github.com/firebase/flutterfire/issues/13269
    throw UnimplementedError();
  }

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) {
    if (_generativeModel == null) {
      throw Exception('generativeModel not initialized');
    }

    return _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: (c) =>
          _generativeModel.generateContentStream([c]),
    );
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) {
    if (_generativeModel == null) {
      throw Exception('generativeModel not initialized');
    }

    assert(_chat != null);

    return _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: _chat!.sendMessageStream,
    );
  }

  Stream<String> _generateStream({
    required String prompt,
    required Iterable<Attachment> attachments,
    required Stream<GenerateContentResponse> Function(Content)
        contentStreamGenerator,
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);

    final response = contentStreamGenerator(content);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null) yield text;
    }
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => InlineDataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FileData(a.mimeType, a.url.toString()),
      };
}
