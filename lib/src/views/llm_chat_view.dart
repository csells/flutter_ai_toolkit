// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import '../models/chat_message.dart';
import 'chat_input.dart';
import 'chat_transcript_view.dart';

class LlmChatView extends StatefulWidget {
  const LlmChatView(this.llmConfig, {super.key});

  final LlmConfig llmConfig;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmChatViewState extends State<LlmChatView> {
  final TextEditingController _controller = TextEditingController();
  final _transcript = List<ChatMessage>.empty(growable: true);
  final bool _isLlmTyping = false;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Expanded(
            child: ChatTranscriptView(_transcript),
          ),
          ChatInput(
            controller: _controller,
            isLlmTyping: _isLlmTyping,
            submit: (String value) => setState(
              () => _transcript.add(ChatMessage.user(value)),
            ),
          ),
        ],
      );
}
