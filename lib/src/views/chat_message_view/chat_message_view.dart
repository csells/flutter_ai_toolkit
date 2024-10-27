// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/views/action_button/action_button.dart';
import 'package:gap/gap.dart';

import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../models/chat_view_model/chat_view_model_client.dart';
import '../../models/llm_chat_message/llm_chat_message.dart';
import '../action_button/action_button_bar.dart';
import '../../styles/llm_chat_view_style.dart';
import 'llm_message_view.dart';
import 'user_message_view.dart';

/// A widget that displays a single chat message with optional selection and
/// editing functionality.
///
/// This widget is responsible for rendering a chat message, handling long press
/// for selection, and providing options to edit or copy the message content.
class ChatMessageView extends StatefulWidget {
  /// Creates a ChatMessageView.
  ///
  /// The [message] parameter is required and represents the chat message to be
  /// displayed. [onEdit] is an optional callback function triggered when the
  /// edit action is selected. [onSelected] is an optional callback function
  /// that is called when the message selection state changes. [selected]
  /// indicates whether the message is currently selected.
  const ChatMessageView({
    required this.message,
    this.onEdit,
    this.onSelected,
    this.selected = false,
    super.key,
  });

  /// The chat message to be displayed.
  final LlmChatMessage message;

  /// Callback function triggered when the edit action is selected.
  final void Function()? onEdit;

  /// Callback function called when the message selection state changes.
  final void Function(bool)? onSelected;

  /// Indicates whether the message is currently selected.
  final bool selected;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
        builder: (context, viewModel, child) {
          final chatStyle = LlmChatViewStyle.resolve(viewModel.style);

          return GestureDetector(
            onLongPress: _onSelect,
            child: Column(
              children: [
                _isUser
                    ? UserMessageView(widget.message)
                    : LlmMessageView(widget.message),
                const Gap(6),
                if (widget.selected)
                  Align(
                    alignment:
                        _isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: ActionButtonBar(
                      _isUser
                          ? [
                              if (widget.onEdit != null)
                                ActionButton(
                                  onPressed: _onEdit,
                                  style: chatStyle.editButtonStyle!,
                                ),
                              ActionButton(
                                onPressed: _onCopy,
                                style: chatStyle.copyButtonStyle!,
                              ),
                              ActionButton(
                                onPressed: _onSelect,
                                style: chatStyle.closeButtonStyle!,
                              ),
                            ]
                          : [
                              ActionButton(
                                onPressed: _onSelect,
                                style: chatStyle.closeButtonStyle!,
                              ),
                              ActionButton(
                                onPressed: _onCopy,
                                style: chatStyle.copyButtonStyle!,
                              ),
                            ],
                    ),
                  ),
              ],
            ),
          );
        },
      );

  void _onSelect() => widget.onSelected?.call(!widget.selected);

  void _onEdit() {
    widget.onSelected?.call(false);
    widget.onEdit?.call();
  }

  Future<void> _onCopy() async {
    widget.onSelected?.call(false);
    await Clipboard.setData(ClipboardData(text: widget.message.text));

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      AdaptiveSnackBar.show(context, 'Message copied to clipboard');
    }
  }
}
