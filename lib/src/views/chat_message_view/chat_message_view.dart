// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/utility.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../providers/interface/chat_message.dart';
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
    super.key,
  });

  /// The chat message to be displayed.
  final ChatMessage message;

  /// Callback function triggered when the edit action is selected.
  final void Function()? onEdit;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
        builder: (context, viewModel, child) {
          final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
          final child = _isUser
              ? UserMessageView(widget.message)
              : LlmMessageView(widget.message);
          final contextMenu = isMobile
              ? ContextMenu(
                  entries: _isUser
                      ? [
                          if (widget.onEdit != null)
                            MenuItem(
                              label: 'Edit',
                              icon: chatStyle.editButtonStyle!.icon,
                              onSelected: widget.onEdit,
                            ),
                          MenuItem(
                            label: 'Copy',
                            icon: chatStyle.copyButtonStyle!.icon,
                            onSelected: _onCopy,
                          ),
                        ]
                      : [
                          MenuItem(
                            label: 'Copy',
                            icon: chatStyle.copyButtonStyle!.icon,
                            onSelected: _onCopy,
                          ),
                        ],
                )
              : null;

          return contextMenu != null
              ? ContextMenuRegion(contextMenu: contextMenu, child: child)
              : child;
        },
      );

  Future<void> _onCopy() async {
    await Clipboard.setData(ClipboardData(text: widget.message.text ?? ''));

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      AdaptiveSnackBar.show(context, 'Message copied to clipboard');
    }
  }
}
