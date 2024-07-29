// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_input.dart';
import 'chat_transcript_view.dart';

class LlmChatView extends StatefulWidget {
  const LlmChatView(this.provider, {super.key});

  final LlmProvider provider;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmChatViewState extends State<LlmChatView> {
  final _transcript = List<ChatMessage>.empty(growable: true);
  bool _isLlmTyping = false;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(child: ChatTranscriptView(_transcript)),
          ChatInput(pauseInput: _isLlmTyping, submit: (text) => _submit(text)),
        ],
      );

  Future<void> _submit(String prompt) async {
    setState(() {
      _transcript.add(ChatMessage.user(prompt));
      _isLlmTyping = true;
    });

    // TODO: stream this response
    final response = await widget.provider.generateStream(prompt).toList();

    setState(() {
      _transcript.add(ChatMessage.llm(response.join('')));
      _isLlmTyping = false;
    });
  }
}
