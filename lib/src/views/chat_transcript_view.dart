import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import 'chat_message_bubble.dart';
import 'typing_indicator.dart';

class ChatTranscriptView extends StatefulWidget {
  const ChatTranscriptView(
    this.transcript, {
    super.key,
  });

  final List<ChatMessage> transcript;

  @override
  State<ChatTranscriptView> createState() => _ChatTranscriptViewState();
}

class _ChatTranscriptViewState extends State<ChatTranscriptView> {
  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            reverse: true,
            itemCount: widget.transcript.length,
            itemBuilder: (context, index) {
              final messageIndex = widget.transcript.length - index - 1;
              final message = widget.transcript[messageIndex];

              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: message.displayString != ''
                    ? ChatMessageBubble(
                        message: message,
                        width: constraints.maxWidth * 0.8,
                        key: ValueKey('message-${message.id}'),
                      )
                    : const TypingIndicator(
                        showIndicator: true,
                      ),
              );
            },
          );
        },
      );
}
