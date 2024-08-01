// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:uuid/uuid.dart';

class ChatMessage {
  ChatMessage._({
    required this.id,
    required this.origin,
    required String body,
  }) : _body = body;

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
        body: '',
      );

  factory ChatMessage.user(String body) => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.user,
        body: body,
      );

  final String id;
  final MessageOrigin origin;
  String _body;

  String get body => _body;

  void append(String text) => _body += text;
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
