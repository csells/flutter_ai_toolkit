// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  ChatMessage._({
    required this.id,
    required this.body,
    required this.origin,
    required int cursorPosition,

    /// Always true for a user's message, but only true for the LLM once it has
    /// finished composing its reply.
    required bool isComplete,
  })  : _cursorPosition = cursorPosition,
        _isComplete = isComplete;

  factory ChatMessage.origin(String body, MessageOrigin origin) =>
      origin == MessageOrigin.user
          ? ChatMessage.user(body)
          : ChatMessage.llm(body);

  factory ChatMessage.llm(String body, {int? cursorPosition}) => ChatMessage._(
        id: const Uuid().v4(),
        body: body,
        origin: MessageOrigin.llm,
        cursorPosition: cursorPosition ?? 0,
        isComplete: false,
      );

  factory ChatMessage.user(String body) => ChatMessage._(
        id: const Uuid().v4(),
        body: body,
        origin: MessageOrigin.user,
        cursorPosition: body.length,
        isComplete: true,
      );

  final String id;
  final String body;
  final MessageOrigin origin;

  int _cursorPosition;
  bool _isComplete;

  int get cursorPosition => _cursorPosition;

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

  bool get displayingFullString => cursorPosition == body.length;
  String get displayString => body;

  void advanceCursor() => ++_cursorPosition;
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

  String get transcriptName => switch (this) {
        MessageOrigin.user => 'USER',
        MessageOrigin.llm => 'LLM',
      };

  Alignment alignmentFromTextDirection(TextDirection textDirection) =>
      switch (textDirection) {
        TextDirection.ltr =>
          isUser ? Alignment.centerRight : Alignment.centerLeft,
        TextDirection.rtl =>
          isUser ? Alignment.centerLeft : Alignment.centerRight,
      };
}
