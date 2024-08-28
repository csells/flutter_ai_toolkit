// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/views/view_styles.dart';
// using flutter_markdown_selectionarea until the following bug is fixed:
// https://github.com/flutter/flutter/issues/107073
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../models/chat_message.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView({
    required this.message,
    this.onEdit,
    super.key,
  });

  final ChatMessage message;
  final void Function()? onEdit;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;
  bool get _hasMessage => widget.message.text.isNotEmpty;
  final bool _isSelected = false;

  @override
  Widget build(BuildContext context) => _isUser
      ? Row(
          children: [
            Flexible(flex: 2, child: Container()),
            Flexible(
              flex: 6,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: unnamedColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.message.text),
                      ),
                    ),
                  ),
                  if (_isSelected)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: widget.onEdit,
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          // TODO: disable copy if the LLM is still generating
                          onPressed: () => _onCopy(context),
                          icon: const Icon(Icons.copy),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                ],
              ),
            ),
          ],
        )
      : Row(
          children: [
            Flexible(
              flex: 6,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE5E5E5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: iconColor,
                          size: 12,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28),
                        child: !_hasMessage
                            ? SizedBox(
                                width: 24,
                                child:
                                    JumpingDotsProgressIndicator(fontSize: 24),
                              )
                            : MarkdownBody(data: widget.message.text),
                      ),
                    ],
                  ),
                  if (_isSelected)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 12),
                        IconButton(
                          // TODO: disable copy if the LLM is still generating
                          onPressed: () => _onCopy(context),
                          icon: const Icon(Icons.copy),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                ],
              ),
            ),
            Flexible(flex: 2, child: Container()),
          ],
        );

  Future<void> _onCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: widget.message.text));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
