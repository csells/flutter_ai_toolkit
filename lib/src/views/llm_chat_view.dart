// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/views/view_styles.dart';

import '../models/chat_message.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_input.dart';
import 'chat_transcript_view.dart';

class LlmChatView extends StatefulWidget {
  const LlmChatView({
    required this.provider,
    super.key,
  });

  final LlmProvider provider;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmResponse {
  final ChatMessage message;
  final void Function()? onDone;
  StreamSubscription<String>? _subscription;

  _LlmResponse({
    required Stream<String> stream,
    required this.message,
    this.onDone,
  }) {
    _subscription = stream.listen(
      (text) => message.append(text),
      onDone: onDone,
      cancelOnError: true,
      onError: _error,
    );
  }

  void cancel() => _close('CANCELED');
  void _error(dynamic err) => _close('ERROR: $err');

  void _close(String s) {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;
    message.append(s);
    onDone?.call();
  }
}

class _LlmChatViewState extends State<LlmChatView> {
  final _transcript = List<ChatMessage>.empty(growable: true);
  _LlmResponse? _current;
  String? _initialInput;

  @override
  Widget build(BuildContext context) => Container(
        color: backgroundColor,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ChatTranscriptView(
                transcript: _transcript,
                onEditMessage: _current == null ? _onEditMessage : null,
              ),
            ),
            ChatInput(
              initialInput: _initialInput,
              submitting: _current != null,
              onSubmit: _onSubmit,
              onCancel: _onCancel,
            ),
          ],
        ),
      );

  Future<void> _onSubmit(
    String prompt,
    Iterable<Attachment> attachments,
  ) async {
    _initialInput = null;

    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();

    _transcript.addAll([userMessage, llmMessage]);

    _current = _LlmResponse(
      stream: widget.provider.generateStream(prompt, attachments: attachments),
      message: llmMessage,
      onDone: _onDone,
    );

    setState(() {});
  }

  void _onDone() => setState(() => _current = null);
  void _onCancel() => _current?.cancel();

  void _onEditMessage(ChatMessage message) {
    assert(_current == null);

    // remove the last llm message
    assert(_transcript.last.origin.isLlm);
    _transcript.removeLast();

    // remove the last user message
    assert(_transcript.last.origin.isUser);
    final userMessage = _transcript.removeLast();

    // set the text of the controller to the last userMessage
    setState(() => _initialInput = userMessage.text);
  }
}
