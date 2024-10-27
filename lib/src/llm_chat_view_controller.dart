// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'providers/interface/attachments.dart';
import 'providers/interface/chat_message.dart';
import 'providers/interface/llm_provider.dart';

/// A controller class for managing LLM chat interactions and view updates.
///
/// This class extends [ChangeNotifier] to provide a way to notify listeners
/// of changes in the chat state.
class LlmChatViewController extends ChangeNotifier {
  /// Creates a new [LlmChatViewController].
  ///
  /// [provider] is the required [LlmProvider] for handling LLM interactions.
  /// [messageSender] is an optional [LlmStreamGenerator] for sending messages.
  LlmChatViewController({
    required LlmProvider provider,
    LlmStreamGenerator? messageSender,
  })  : _provider = provider,
        _messageSender = messageSender;

  final LlmProvider _provider;
  final LlmStreamGenerator? _messageSender;

  /// Generates a stream of text from the LLM based on a prompt and attachments.
  ///
  /// [prompt] is the text prompt to send to the LLM.
  /// [attachments] is a required list of file attachments to include with the prompt.
  ///
  /// Returns a [Stream] of [String] containing the LLM's generated response.
  /// The response is streamed back as it is generated.
  Stream<String> generateStream(
    String prompt, {
    required List<FileAttachment> attachments,
  }) =>
      _provider.generateStream(prompt, attachments: attachments);

  /// Sends a message to the LLM and returns a stream of the response.
  ///
  /// [prompt] is the message to send to the LLM.
  /// [attachments] is an optional list of attachments to include with the message.
  ///
  /// Notifies listeners when a new message is added to the history and when
  /// the full LLM response is available.
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final messageSender = _messageSender ?? _provider.sendMessageStream;
    final stream = messageSender(prompt, attachments: attachments);

    // Notify listeners that a new message has been added to the history
    notifyListeners();

    await for (final text in stream) {
      yield text;

      // Notify listeners that more of the LLM response is now available
      notifyListeners();
    }

    // Notify listeners that the complete LLM response is now available
    notifyListeners();
  }

  /// Gets the current chat history.
  Iterable<ChatMessage> get history => _provider.history;

  /// Sets the chat history and notifies listeners of the change.
  set history(Iterable<ChatMessage> history) {
    _provider.history = history;
    notifyListeners();
  }
}
