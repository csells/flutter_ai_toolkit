// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../providers/interface/attachments.dart';
import 'message_origin.dart';

/// Represents a message in a chat conversation.
///
/// This class encapsulates the properties and behavior of a chat message,
/// including its unique identifier, origin (user or LLM), text content,
/// and any attachments.
class ChatMessage {
  /// Constructs a [ChatMessage] instance.
  ///
  /// The [origin] parameter specifies the origin of the message (user or LLM).
  /// The [text] parameter is the content of the message. It can be null or
  /// empty if the message is from an LLM. For user-originated messages, [text]
  /// must not be null or empty. The [attachments] parameter is a list of any
  /// files or media attached to the message.
  ChatMessage({
    required this.origin,
    required String? text,
    required this.attachments,
  })  : _text = text,
        assert(
            origin.isUser && text != null && text.isNotEmpty || origin.isLlm);

  /// Factory constructor for creating an LLM-originated message.
  ///
  /// Creates a message with an empty text content and no attachments.
  factory ChatMessage.llm() => ChatMessage(
        origin: MessageOrigin.llm,
        text: null,
        attachments: [],
      );

  /// Factory constructor for creating an LLM-originated greeting message.
  ///
  /// [welcomeMessage] is the content of the greeting message.
  factory ChatMessage.llmWelcome(String welcomeMessage) => ChatMessage(
        origin: MessageOrigin.llm,
        text: welcomeMessage,
        attachments: [],
      );

  /// Factory constructor for creating a user-originated message.
  ///
  /// [text] is the content of the user's message.
  /// [attachments] are any files or media the user has attached to the message.
  factory ChatMessage.user(String text, Iterable<Attachment> attachments) =>
      ChatMessage(
        origin: MessageOrigin.user,
        text: text,
        attachments: attachments,
      );
  String? _text;

  /// The origin of the message (user or LLM).
  final MessageOrigin origin;

  /// Any attachments associated with the message.
  final Iterable<Attachment> attachments;

  /// Getter for the text content of the message.
  String? get text => _text?.trim();

  /// Appends additional text to the existing message content.
  ///
  /// This is typically used for LLM messages that are streamed in parts.
  void append(String text) => _text = (_text ?? '') + text;

  @override
  String toString() => 'ChatMessage('
      'origin: $origin, '
      'text: $text, '
      'attachments: $attachments'
      ')';
}
