import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    required this.message,
    required this.width,
    super.key,
  });

  final ChatMessage message;
  final double width;

  // Colors.blue[400]
  static const llmBgColor = Color(0xFF42A5F5);

  // Colors.orange[400]
  static const userBgColor = Color(0xFFFFA726);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (message.origin.isUser) Flexible(flex: 2, child: Container()),
        Flexible(
          flex: 6,
          child: BubbleSpecialThree(
            text: message.displayString,
            color: message.origin.isUser ? userBgColor : llmBgColor,
            isSender: message.origin.isUser,
            textStyle: const TextStyle(color: Colors.white),
            sent: message.isComplete,
            delivered: message.isComplete,
            seen: message.isComplete,
          ),
        ),
        if (message.origin.isLlm) Flexible(flex: 2, child: Container()),
      ],
    );
  }
}
