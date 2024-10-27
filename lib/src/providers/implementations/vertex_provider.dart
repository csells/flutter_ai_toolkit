// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_ai_toolkit/src/providers/interface/chat_message.dart';

import '../interface/attachments.dart';
import '../interface/llm_provider.dart';
import '../interface/message_origin.dart';

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
  ///
  /// [history] is an optional list of previous chat messages to initialize the
  /// chat session with.
  ///
  /// [safetySettings] is an optional list of safety settings to apply to the
  /// model's responses.
  ///
  /// [generationConfig] is an optional configuration for controlling the model's
  /// generation behavior.
  VertexProvider({
    GenerativeModel? generativeModel,
    GenerativeModel? embeddingModel,
    Iterable<ChatMessage>? history,
    List<SafetySetting>? safetySettings,
    GenerationConfig? generationConfig,
  })  : _generativeModel = generativeModel,
        _embeddingModel = embeddingModel,
        _safetySettings = safetySettings,
        _generationConfig = generationConfig {
    _chat = _startChat(history?.map(_contentFrom).toList());
  }

  final GenerativeModel? _generativeModel;
  final GenerativeModel? _embeddingModel;
  final List<SafetySetting>? _safetySettings;
  final GenerationConfig? _generationConfig;
  ChatSession? _chat;

  ChatSession? _startChat(List<Content>? history) =>
      _generativeModel?.startChat(
        history: history,
        safetySettings: _safetySettings,
        generationConfig: _generationConfig,
      );

  @override
  Future<List<double>> getDocumentEmbedding(String document) =>
      _getEmbedding(document, TaskType.retrievalDocument);

  @override
  Future<List<double>> getQueryEmbedding(String query) =>
      _getEmbedding(query, TaskType.retrievalQuery);

  Future<List<double>> _getEmbedding(String s, TaskType embeddingTask) async {
    _checkModel('embeddingModel', _embeddingModel);
    assert(embeddingTask == TaskType.retrievalDocument ||
        embeddingTask == TaskType.retrievalQuery);

    // waiting for: https://github.com/firebase/flutterfire/issues/13269
    throw UnimplementedError('VertexProvider${switch (embeddingTask) {
      TaskType.retrievalDocument => 'getDocumentEmbedding',
      TaskType.retrievalQuery => 'getQueryEmbedding',
      _ => 'getEmbedding',
    }}');
  }

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) {
    _checkModel('generativeModel', _generativeModel);
    return _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: (c) =>
          _generativeModel!.generateContentStream([c]),
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

  @override
  Iterable<ChatMessage> get history {
    _checkModel('generativeModel', _generativeModel);
    return _chat!.history
        .where((c) => c.role == 'user' || c.role == 'model')
        .map(_messageFrom);
  }

  @override
  set history(Iterable<ChatMessage> history) =>
      _chat = _startChat(history.map(_contentFrom).toList());

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => InlineDataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FileData(a.mimeType, a.url.toString()),
      };

  Content _contentFrom(ChatMessage message) => Content(
        message.origin.isUser ? 'user' : 'model',
        [
          TextPart(message.text ?? ''),
          ...message.attachments.map(_partFrom),
        ],
      );

  // TODO: get the FileAttachmentname and check the mapping
  Attachment _attachmentFrom(Part part) => switch (part) {
        (InlineDataPart p) =>
          FileAttachment(name: '', mimeType: p.mimeType, bytes: p.bytes),
        (FileData p) => LinkAttachment(name: '', url: Uri.parse(p.fileUri)),
        _ => throw UnimplementedError('Unsupported part type: $part'),
      };

  ChatMessage _messageFrom(Content content) => ChatMessage(
        text: content.parts.whereType<TextPart>().map((p) => p.text).join(),
        origin: content.role == 'user' ? MessageOrigin.user : MessageOrigin.llm,
        attachments: content.parts.map(_attachmentFrom).toList(),
      );

  void _checkModel(String name, GenerativeModel? model) {
    if (model == null) throw Exception('$name is not initialized');
  }
}
