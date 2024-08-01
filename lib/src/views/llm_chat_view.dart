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
  ChatMessage? _pendingLlmResponse;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(child: ChatTranscriptView(_transcript)),
          ChatInput(onSubmit: _pendingLlmResponse == null ? _submit : null),
        ],
      );

  Future<void> _submit(String prompt) async {
    setState(() {
      _transcript.add(ChatMessage.user(prompt));
      _pendingLlmResponse = ChatMessage.llm();
      _transcript.add(_pendingLlmResponse!);
    });

    await for (final text in widget.provider.generateStream(prompt)) {
      setState(() => _pendingLlmResponse!.append(text));
    }

    setState(() => _pendingLlmResponse = null);
  }
}
