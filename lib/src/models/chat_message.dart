// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:uuid/uuid.dart';

import '../providers/llm_provider_interface.dart';

class ChatMessage {
  ChatMessage._({
    required this.id,
    required this.origin,
    required String text,
    required this.attachments,
  })  : _text = text,
        assert(
          origin.isUser && text.isNotEmpty || origin.isLlm && text.isEmpty,
        );

  factory ChatMessage.llm() => ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.llm,
        text: '',
        attachments: [],
      );

  factory ChatMessage.user(String text, Iterable<Attachment> attachments) =>
      ChatMessage._(
        id: const Uuid().v4(),
        origin: MessageOrigin.user,
        text: text,
        attachments: attachments,
      );

  final String id;
  final MessageOrigin origin;
  String _text;
  final Iterable<Attachment> attachments;

  String get text => _text;
  void append(String text) => _text += text;
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
