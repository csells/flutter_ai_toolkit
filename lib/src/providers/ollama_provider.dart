// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ollama_dart/ollama_dart.dart';

import 'llm_provider_interface.dart';

/// A provider for interacting with Ollama models.
class OllamaProvider extends LlmProvider {
  /// Creates an [OllamaProvider] instance.
  ///
  /// [model] is the name of the Ollama model to use.
  /// [systemInstruction] is an optional system message to set the behavior of the model.
  OllamaProvider({
    required this.model,
    this.systemInstruction = 'You are a helpful assistant.',
  }) {
    _messages.add(
      Message(role: MessageRole.system, content: systemInstruction),
    );
  }

  /// The name of the Ollama model to use.
  final String model;

  /// The system instruction used to set the behavior of the model.
  final String systemInstruction;

  final _client = OllamaClient();
  final _messages = <Message>[];

  @override
  Future<List<double>> getDocumentEmbedding(String document) {
    throw UnimplementedError('OllamaProvider.getDocumentEmbedding');
  }

  @override
  Future<List<double>> getQueryEmbedding(String query) {
    throw UnimplementedError('OllamaProvider.getQueryEmbedding');
  }

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    // need to add support for attachments
    if (attachments.isNotEmpty) {
      throw UnimplementedError('No support for attachments yet');
    }

    final stream = _client.generateCompletionStream(
      request: GenerateCompletionRequest(
        model: model,
        prompt: prompt,
      ),
    );

    await for (final response in stream) {
      final text = response.response;
      if (text != null && text.isNotEmpty) yield text;
    }
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    // need to add support for attachments
    if (attachments.isNotEmpty) {
      throw UnimplementedError('No support for attachments yet');
    }

    _messages.add(Message(role: MessageRole.user, content: prompt));

    final stream = _client.generateChatCompletionStream(
      request: GenerateChatCompletionRequest(
        model: model,
        messages: _messages,
      ),
    );

    var content = '';
    await for (final response in stream) {
      final text = response.message.content;
      if (text.isNotEmpty) {
        yield text;
        content += text;
      }
    }

    _messages.add(Message(role: MessageRole.assistant, content: content));
  }
}
