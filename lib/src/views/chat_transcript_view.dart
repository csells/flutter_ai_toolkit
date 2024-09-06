// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import '../models/chat_message.dart';
import 'chat_message_view.dart';

/// A widget that displays a transcript of chat messages.
///
/// This widget renders a scrollable list of chat messages, supporting
/// selection and editing of messages. It displays messages in reverse
/// chronological order (newest at the bottom).
///
/// The [transcript] parameter is a list of [ChatMessage] objects to display.
/// The optional [onEditMessage] callback allows editing of messages when
/// triggered.
class ChatTranscriptView extends StatefulWidget {
  /// Creates a [ChatTranscriptView].
  ///
  /// The [transcript] parameter is required and contains the list of chat messages to display.
  /// The [onEditMessage] parameter is optional and provides a callback for editing messages.
  ///
  /// If [onEditMessage] is provided, it will be called when a user initiates an edit action
  /// on an editable message (typically the last user message in the transcript).
  const ChatTranscriptView({
    required this.transcript,
    this.onEditMessage,
    super.key,
  });

  /// The list of chat messages to display in the transcript.
  final List<ChatMessage> transcript;

  /// Optional callback function for editing a message.
  ///
  /// If provided, this function will be called when a user initiates an edit
  /// action on an editable message (typically the last user message in the
  /// transcript). The function receives the [ChatMessage] to be edited as its
  /// parameter.
  final void Function(ChatMessage message)? onEditMessage;

  @override
  State<ChatTranscriptView> createState() => _ChatTranscriptViewState();
}

class _ChatTranscriptViewState extends State<ChatTranscriptView> {
  int _selectedMessageIndex = -1;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => ListView.builder(
          reverse: true,
          itemCount: widget.transcript.length,
          itemBuilder: (context, index) {
            final messageIndex = widget.transcript.length - index - 1;
            final message = widget.transcript[messageIndex];
            final isLastUserMessage = message.origin.isUser &&
                messageIndex >= widget.transcript.length - 2;

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
      );

  void _onSelectMessage(int messageIndex, bool selected) =>
      setState(() => _selectedMessageIndex = selected ? messageIndex : -1);
}
