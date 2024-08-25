// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// using flutter_markdown_selectionarea until the following bug is fixed:
// https://github.com/flutter/flutter/issues/107073
import 'package:flutter_markdown_selectionarea/flutter_markdown.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../models/chat_message.dart';

class ChatMessageView extends StatelessWidget {
  const ChatMessageView({
    required this.message,
    this.onEdit,
    super.key,
  });

  final ChatMessage message;
  final void Function()? onEdit;

  // Colors.blue[400]
  static const llmBgColor = Color(0xFF42A5F5);

  // Colors.orange[400]
  static const userBgColor = Color(0xFFFFA726);

  static const whiteTextStyle = TextStyle(color: Colors.white);
  static const blackTextStyle = TextStyle(color: Colors.black);

  bool get _isUser => message.origin.isUser;
  bool get _hasMessage => message.body.isNotEmpty;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (_isUser) Flexible(flex: 2, child: Container()),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                Align(
                  alignment: _isUser ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.only(
                        topLeft:
                            _isUser ? const Radius.circular(16) : Radius.zero,
                        topRight:
                            _isUser ? Radius.zero : const Radius.circular(16),
                        bottomLeft: const Radius.circular(16),
                        bottomRight: const Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: !_hasMessage
                          ? SizedBox(
                              width: 24,
                              child: JumpingDotsProgressIndicator(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize!,
                              ),
                            )
                          : SelectionArea(
                              child: MarkdownBody(data: message.body)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: message.origin.isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 12),
                    if (message.origin.isUser)
                      IconButton(
                        onPressed: onEdit,
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
          if (message.origin.isLlm) Flexible(flex: 2, child: Container()),
        ],
      );

  Future<void> _onCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: message.body));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
