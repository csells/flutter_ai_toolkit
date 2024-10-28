// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'providers/interface/attachments.dart';
import 'providers/interface/chat_message.dart';
import 'providers/interface/llm_provider.dart';
import 'providers/interface/message_origin.dart';

/// A controller class for managing LLM chat interactions and view updates.
///
/// This class extends [ChangeNotifier] to provide a way to notify listeners
/// of changes in the chat state.
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
    if (_messageSender != null) {
      yield* _messageSender(prompt, attachments: attachments);
    } else {
      yield* _provider.sendMessageStream(prompt, attachments: attachments);
      notifyListeners();
    }
  }

  /// Gets the current chat history.
  Iterable<ChatMessage> get history => _provider.history;

  /// Sets the chat history and notifies listeners of the change.
  set history(Iterable<ChatMessage> history) {
    _provider.history = history;
    notifyListeners();
  }

  /// Clears the chat history and notifies listeners of the change.
  void clearHistory() => history = const [];

  /// Converts a [ChatMessage] to a map representation.
  ///
  /// The map contains the following keys:
  /// - 'origin': The origin of the message (user or model).
  /// - 'text': The text content of the message.
  /// - 'attachments': A list of attachments, each represented as a map with:
  ///   - 'type': The type of the attachment ('file' or 'link').
  ///   - 'name': The name of the attachment.
  ///   - 'mimeType': The MIME type of the attachment.
  ///   - 'data': The data of the attachment, either as a base64 encoded string (for files) or a URL (for links).
  static Map<String, dynamic> mapFrom(ChatMessage message) => {
        'origin': message.origin.name,
        'text': message.text,
        'attachments': [
          for (final attachment in message.attachments)
            {
              'type': switch (attachment) {
                (FileAttachment _) => 'file',
                (LinkAttachment _) => 'link',
              },
              'name': attachment.name,
              'mimeType': switch (attachment) {
                (FileAttachment a) => a.mimeType,
                (LinkAttachment a) => a.mimeType,
              },
              'data': switch (attachment) {
                (FileAttachment a) => base64Encode(a.bytes),
                (LinkAttachment a) => a.url,
              },
            },
        ],
      };

  /// Converts a map representation to a [ChatMessage].
  ///
  /// The map should contain the following keys:
  /// - 'origin': The origin of the message (user or model).
  /// - 'text': The text content of the message.
  /// - 'attachments': A list of attachments, each represented as a map with:
  ///   - 'type': The type of the attachment ('file' or 'link').
  ///   - 'name': The name of the attachment.
  ///   - 'mimeType': The MIME type of the attachment.
  ///   - 'data': The data of the attachment, either as a base64 encoded string (for files) or a URL (for links).
  static ChatMessage messageFrom(Map<String, dynamic> map) => ChatMessage(
        origin: MessageOrigin.values.byName(map['origin'] as String),
        text: map['text'] as String,
        attachments: [
          for (final attachment in map['attachments'] as List<dynamic>)
            switch (attachment['type'] as String) {
              'file' => FileAttachment.fileOrImage(
                  name: attachment['name'] as String,
                  mimeType: attachment['mimeType'] as String,
                  bytes: base64Decode(attachment['data'] as String),
                ),
              'link' => LinkAttachment(
                  name: attachment['name'] as String,
                  url: Uri.parse(attachment['data'] as String),
                ),
              _ => throw UnimplementedError(),
            },
        ],
      );
}
