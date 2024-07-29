// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.submit,
    required this.isLlmTyping,
    super.key,
  });

  /// Callback for submitting new messages
  final void Function(String) submit;

  /// Prevents submitting new messages when true
  final bool isLlmTyping;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => _submit(value),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => IconButton(
              icon: const Icon(Icons.send),
              onPressed: _controller.text.isEmpty || widget.isLlmTyping
                  ? null
                  : () => _submit(_controller.text),
            ),
          ),
        ],
      );

  void _submit(String text) {
    widget.submit(text);
    _controller.clear();
  }
}
