// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.submitting,
    required this.onSubmit,
    required this.onCancel,
    this.initialInput,
    super.key,
  });

  final String? initialInput;
  final bool submitting;
  final void Function(String) onSubmit;
  final void Function() onCancel;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

enum _InputState { disabled, enabled, submitting }

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialInput != null) _controller.text = widget.initialInput!;
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
              child: TextField(
                minLines: 1,
                maxLines: 1024,
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (value) => _onSubmit(value),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  hintText: "Prompt the LLM",
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _controller,
              builder: (context, value, child) => switch (_inputState) {
                    _InputState.disabled => const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.send),
                      ),
                    _InputState.enabled => IconButton(
                        onPressed: () => _onSubmit(value.text),
                        icon: const Icon(Icons.send),
                      ),
                    _InputState.submitting => IconButton(
                        onPressed: _onCancel,
                        icon: const Icon(Icons.stop),
                      ),
                  }),
        ],
      );

  _InputState get _inputState {
    if (widget.submitting) return _InputState.submitting;
    if (_controller.text.isNotEmpty) return _InputState.enabled;
    assert(!widget.submitting && _controller.text.isEmpty);
    return _InputState.disabled;
  }

  void _onSubmit(String prompt) {
    assert(_inputState == _InputState.enabled);
    widget.onSubmit(prompt);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onCancel() {
    assert(_inputState == _InputState.submitting);
    widget.onCancel();
    _controller.clear();
    _focusNode.requestFocus();
  }
}
