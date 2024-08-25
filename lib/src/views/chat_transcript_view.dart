// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import 'chat_message_view.dart';

class ChatTranscriptView extends StatelessWidget {
  const ChatTranscriptView({
    required this.transcript,
    this.onEditMessage,
    super.key,
  });

  final List<ChatMessage> transcript;
  final void Function(ChatMessage message)? onEditMessage;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          reverse: true,
          itemCount: transcript.length,
          itemBuilder: (context, index) {
            final messageIndex = transcript.length - index - 1;
            final message = transcript[messageIndex];
            final isLastUserMessage =
                message.origin.isUser && messageIndex >= transcript.length - 2;

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ChatMessageView(
                message: message,
                key: ValueKey('message-${message.id}'),
                onEdit: isLastUserMessage && onEditMessage != null
                    ? () => onEditMessage?.call(message)
                    : null,
              ),
            );
          },
        ),
      );
}
