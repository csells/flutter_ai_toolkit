// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/src/views/bubble_special_three_plus.dart';
// using flutter_markdown_selectionarea until the following bug is fixed:
// https://github.com/flutter/flutter/issues/107073
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';

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

  static const whiteTextStyle = TextStyle(color: Colors.white);
  static const blackTextStyle = TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (message.origin.isUser) Flexible(flex: 2, child: Container()),
          Flexible(
            flex: 6,
            child: BubbleSpecialThreePlus(
              color: message.origin.isUser ? userBgColor : llmBgColor,
              isSender: message.origin.isUser,
              child: SelectionArea(
                child: MarkdownBody(
                  data: message.body,
                  styleSheet: MarkdownStyleSheet(
                    p: whiteTextStyle,
                    listBullet: whiteTextStyle,
                    tableBorder: TableBorder.all(color: Colors.white),
                    tableHead: whiteTextStyle,
                    tableBody: whiteTextStyle,
                    h1: whiteTextStyle,
                    h2: whiteTextStyle,
                    h3: whiteTextStyle,
                    h4: whiteTextStyle,
                    h5: whiteTextStyle,
                    h6: whiteTextStyle,
                    checkbox: whiteTextStyle,
                    code: const TextStyle(
                      fontFamily: 'Courier New',
                      fontWeight: FontWeight.bold,
                    ),
                    blockquote: blackTextStyle, // NOTE: doesn't seem to work
                  ),
                ),
              ),
            ),
          ),
          if (message.origin.isLlm) Flexible(flex: 2, child: Container()),
        ],
      );
}
