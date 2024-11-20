// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/foundation.dart';

import '../interface/attachments.dart';
import '../interface/chat_message.dart';
import '../interface/llm_provider.dart';

/// A provider class for interacting with Firebase Vertex AI's language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using Firebase Vertex AI's generative model.
class VertexProvider extends LlmProvider with ChangeNotifier {
  /// Creates a new instance of [VertexProvider].
  ///
  /// [model] is an optional [GenerativeModel] instance for text generation. If
  /// provided, it will be used for chat-based interactions and text generation.
  ///
  /// [history] is an optional list of previous chat messages to initialize the
  /// chat session with.
  ///
  /// [chatSafetySettings] is an optional list of safety settings to apply to
  /// the model's responses.
  ///
  /// [generationConfig] is an optional configuration for controlling the
  /// model's generation behavior.
  @immutable
  VertexProvider({
    GenerativeModel? model,
    Iterable<ChatMessage>? history,
    List<SafetySetting>? chatSafetySettings,
    GenerationConfig? generationConfig,
  })  : _model = model,
        _history = history?.toList() ?? [],
        _chatSafetySettings = chatSafetySettings,
        _generationConfig = generationConfig {
    _chat = _startChat(history);
  }

  final GenerativeModel? _model;
  final List<SafetySetting>? _chatSafetySettings;
  final GenerationConfig? _generationConfig;
  final List<ChatMessage> _history;
  ChatSession? _chat;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) {
    if (_model == null) throw Exception('model is not initialized');

    return _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: (c) => _model.generateContentStream([c]),
    );
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    if (_model == null) throw Exception('model is not initialized');

    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    _history.addAll([userMessage, llmMessage]);

    final chunks = _generateStream(
      prompt: prompt,
      attachments: attachments,
      contentStreamGenerator: _chat!.sendMessageStream,
    );

    await for (final chunk in chunks) {
      llmMessage.append(chunk);
      yield chunk;
    }

    // notify listeners that the history has changed when response is complete
    notifyListeners();
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
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    _chat = _startChat(history);
    notifyListeners();
  }

  ChatSession? _startChat(Iterable<ChatMessage>? history) => _model?.startChat(
        history: history?.map(_contentFrom).toList(),
        safetySettings: _chatSafetySettings,
        generationConfig: _generationConfig,
      );

  static Part _partFrom(Attachment attachment) => switch (attachment) {
        (final FileAttachment a) => InlineDataPart(a.mimeType, a.bytes),
        (final LinkAttachment a) => FileData(a.mimeType, a.url.toString()),
      };

  static Content _contentFrom(ChatMessage message) => Content(
        message.origin.isUser ? 'user' : 'model',
        [
          TextPart(message.text ?? ''),
          ...message.attachments.map(_partFrom),
        ],
      );
}
