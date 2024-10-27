// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_view_model/chat_view_model_client.dart';
import '../models/llm_chat_message/llm_chat_message.dart';
import 'chat_message_view/chat_message_view.dart';

/// A widget that displays a transcript of chat messages.
///
/// This widget renders a scrollable list of chat messages, supporting
/// selection and editing of messages. It displays messages in reverse
/// chronological order (newest at the bottom).
class ChatHistoryView extends StatefulWidget {
  /// Creates a [ChatHistoryView].
  ///
  /// If [onEditMessage] is provided, it will be called when a user initiates an
  /// edit action on an editable message (typically the last user message in the
  /// transcript).
  const ChatHistoryView({
    this.onEditMessage,
    super.key,
  });

  /// Optional callback function for editing a message.
  ///
  /// If provided, this function will be called when a user initiates an edit
  /// action on an editable message (typically the last user message in the
  /// transcript). The function receives the [LlmChatMessage] to be edited as its
  /// parameter.
  final void Function(LlmChatMessage message)? onEditMessage;

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  int _selectedMessageIndex = -1;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: ChatViewModelClient(
          builder: (context, viewModel, child) => ListView.builder(
            reverse: true,
            itemCount: viewModel.transcript.length,
            itemBuilder: (context, index) {
              final messageIndex = viewModel.transcript.length - index - 1;
              final message = viewModel.transcript[messageIndex];
              final isLastUserMessage = message.origin.isUser &&
                  messageIndex >= viewModel.transcript.length - 2;

              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: ChatMessageView(
                  message: message,
                  key: ValueKey('message-${message.id}'),
                  onEdit: isLastUserMessage && widget.onEditMessage != null
                      ? () => widget.onEditMessage?.call(message)
                      : null,
                  onSelected: (selected) => _onSelectMessage(
                    messageIndex,
                    selected,
                  ),
                  selected: _selectedMessageIndex == messageIndex,
                ),
              );
            },
          ),
        ),
      );

  void _onSelectMessage(int messageIndex, bool selected) =>
      setState(() => _selectedMessageIndex = selected ? messageIndex : -1);
}
