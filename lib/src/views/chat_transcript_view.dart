// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import 'chat_message_bubble.dart';
import 'typing_indicator.dart';

class ChatTranscriptView extends StatelessWidget {
  const ChatTranscriptView(this.transcript, {super.key});

  final List<ChatMessage> transcript;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          reverse: true,
          itemCount: transcript.length,
          itemBuilder: (context, index) {
            final messageIndex = transcript.length - index - 1;
            final message = transcript[messageIndex];

            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: message.displayString.isNotEmpty
                  ? ChatMessageBubble(
                      message: message,
                      width: constraints.maxWidth * 0.8,
                      key: ValueKey('message-${message.id}'),
                    )
                  : const TypingIndicator(showIndicator: true),
            );
          },
        ),
      );
}
