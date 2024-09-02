// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import 'chat_message_view.dart';

class ChatTranscriptView extends StatefulWidget {
  const ChatTranscriptView({
    required this.transcript,
    this.onEditMessage,
    super.key,
  });

  final List<ChatMessage> transcript;
  final void Function(ChatMessage message)? onEditMessage;

  @override
  State<ChatTranscriptView> createState() => _ChatTranscriptViewState();
}

class _ChatTranscriptViewState extends State<ChatTranscriptView> {
  int _selectedMessageIndex = -1;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          reverse: true,
          itemCount: widget.transcript.length,
          itemBuilder: (context, index) {
            final messageIndex = widget.transcript.length - index - 1;
            final message = widget.transcript[messageIndex];
            final isLastUserMessage = message.origin.isUser &&
                messageIndex >= widget.transcript.length - 2;

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ChatMessageView(
                message: message,
                key: ValueKey('message-${message.id}'),
                onEdit: isLastUserMessage && widget.onEditMessage != null
                    ? () => widget.onEditMessage?.call(message)
                    : null,
                onSelected: (selected) => _onSelectMessage(
                  messageIndex,
                  selected,
                ),
                selected: _selectedMessageIndex == messageIndex,
              ),
            );
          },
        ),
      );

  void _onSelectMessage(int messageIndex, bool selected) =>
      setState(() => _selectedMessageIndex = selected ? messageIndex : -1);
}
