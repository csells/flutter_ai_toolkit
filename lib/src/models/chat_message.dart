// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:uuid/uuid.dart';

class ChatMessage {
  ChatMessage._({
    required this.id,
    required this.origin,

    /// Always true for a user's message, but only true for the LLM once it has
    /// finished composing its reply.
    required bool isComplete,
    required String body,
  })  : _body = body,
        _isComplete = isComplete;

  factory ChatMessage.origin(String body, MessageOrigin origin) {
    assert(origin == MessageOrigin.user && body.isNotEmpty ||
        origin == MessageOrigin.llm && body.isEmpty);

    return origin == MessageOrigin.user
        ? ChatMessage.user(body)
        : ChatMessage.llm();
  }

  factory ChatMessage.llm() => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.llm,
        isComplete: false,
        body: '',
      );

  factory ChatMessage.user(String body) => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.user,
        isComplete: true,
        body: body,
      );

  final String id;
  final MessageOrigin origin;

  bool _isComplete;
  String _body;

  String get body => _body;

  void append(String text) => _body += text;

  /// Always true for a user's message, but only true for the LLM once it has
  /// finished composing its reply.
  bool get isComplete => _isComplete;

  /// Always true for a user's message, but only true for the LLM once it has
  /// finished composing its reply.
  set isComplete(bool value) {
    assert(() {
      if (origin.isUser) {
        throw Exception(
          'Only expected to complete messages from the LLM. '
          'Did you set isComplete on the wrong ChatMessage?',
        );
      }
      return true;
    }());

    _isComplete = true;
  }
}

enum MessageOrigin {
  user,
  llm;

  bool get isUser => switch (this) {
        MessageOrigin.user => true,
        MessageOrigin.llm => false,
      };

  bool get isLlm => switch (this) {
        MessageOrigin.user => false,
        MessageOrigin.llm => true,
      };
}
