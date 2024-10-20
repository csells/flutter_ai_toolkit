// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:uuid/uuid.dart';

import '../providers/llm_provider_interface.dart';

/// Represents a message in a chat conversation.
///
/// This class encapsulates the properties and behavior of a chat message,
/// including its unique identifier, origin (user or LLM), text content,
/// and any attachments.
class ChatMessage {
  /// Private constructor for creating a ChatMessage instance.
  ///
  /// [id] is a unique identifier for the message.
  /// [origin] specifies whether the message is from a user or an LLM.
  /// [text] is the content of the message.
  /// [attachments] are any files or media associated with the message.
  ChatMessage._({
    required this.id,
    required this.origin,
    required String text,
    required this.attachments,
  })  : _text = text,
        assert(origin.isUser && text.isNotEmpty || origin.isLlm);

  /// Factory constructor for creating an LLM-originated message.
  ///
  /// Creates a message with an empty text content and no attachments.
  factory ChatMessage.llm() => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.llm,
        text: '',
        attachments: [],
      );

  /// Factory constructor for creating an LLM-originated greeting message.
  ///
  /// [welcomeMessage] is the content of the greeting message.
  factory ChatMessage.llmWelcome(String welcomeMessage) => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.llm,
        text: welcomeMessage,
        attachments: [],
      );

  /// Factory constructor for creating a user-originated message.
  ///
  /// [text] is the content of the user's message.
  /// [attachments] are any files or media the user has attached to the message.
  factory ChatMessage.user(String text, Iterable<Attachment> attachments) =>
      ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.user,
        text: text,
        attachments: attachments,
      );

  /// The unique identifier of the message.
  final String id;

  /// The origin of the message (user or LLM).
  final MessageOrigin origin;

  /// The text content of the message.
  String _text;

  /// Any attachments associated with the message.
  final Iterable<Attachment> attachments;

  /// Getter for the text content of the message.
  String get text => _text.trim();

  /// Appends additional text to the existing message content.
  ///
  /// This is typically used for LLM messages that are streamed in parts.
  void append(String text) => _text += text;
}

/// Represents the origin of a chat message.
enum MessageOrigin {
  /// Indicates that the message originated from the user.
  user,

  /// Indicates that the message originated from the LLM.
  llm;

  /// Checks if the message origin is from the user.
  ///
  /// Returns `true` if the origin is [MessageOrigin.user], `false` otherwise.
  bool get isUser => switch (this) {
        MessageOrigin.user => true,
        MessageOrigin.llm => false,
      };

  /// Checks if the message origin is from the LLM.
  ///
  /// Returns `true` if the origin is [MessageOrigin.llm], `false` otherwise.
  bool get isLlm => switch (this) {
        MessageOrigin.user => false,
        MessageOrigin.llm => true,
      };
}
