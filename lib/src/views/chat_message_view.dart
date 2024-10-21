// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/views/circle_button.dart';
import 'package:flutter_ai_toolkit/src/views/view_styles.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';

import '../fat_icons.dart';
import '../models/chat_message.dart';
import 'attachment_view.dart';
import 'jumping_dots_progress.dart';
import 'response_builder.dart';

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
    this.responseBuilder,
    super.key,
  });

  /// The chat message to be displayed.
  final ChatMessage message;

  /// Callback function triggered when the edit action is selected.
  final void Function()? onEdit;

  /// Callback function called when the message selection state changes.
  final void Function(bool)? onSelected;

  /// Indicates whether the message is currently selected.
  final bool selected;

  /// A builder function that returns a widget for displaying the message.
  final ResponseBuilder? responseBuilder;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: _onSelect,
        child: Column(
          children: [
            _isUser
                ? _UserMessageView(widget.message)
                : _LlmMessageView(
                    widget.message,
                    responseBuilder: widget.responseBuilder,
                  ),
            const Gap(6),
            if (widget.selected)
              Align(
                alignment:
                    _isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: CircleButtonBar(
                  _isUser
                      ? [
                          if (widget.onEdit != null)
                            CircleButton(
                              onPressed: _onEdit,
                              icon: Icons.edit,
                            ),
                          CircleButton(
                            onPressed: () => _onCopy(context),
                            icon: Icons.copy,
                          ),
                          CircleButton(
                            onPressed: _onSelect,
                            icon: Icons.close,
                            color: FatColors.greyBackground,
                          ),
                        ]
                      : [
                          CircleButton(
                            onPressed: _onSelect,
                            icon: Icons.close,
                            color: FatColors.greyBackground,
                          ),
                          CircleButton(
                            onPressed: () => _onCopy(context),
                            icon: Icons.copy,
                          ),
                        ],
                ),
              ),
          ],
        ),
      );

  void _onSelect() => widget.onSelected?.call(!widget.selected);

  void _onEdit() {
    widget.onSelected?.call(false);
    widget.onEdit?.call();
  }

  Future<void> _onCopy(BuildContext context) async {
    widget.onSelected?.call(false);
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

class _UserMessageView extends StatelessWidget {
  const _UserMessageView(this.message);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(flex: 2, child: SizedBox()),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                ...[
                  for (final attachment in message.attachments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: 80,
                          width: 200,
                          child: AttachmentView(attachment),
                        ),
                      ),
                    ),
                ],
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: FatColors.userMessageBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(message.text),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _LlmMessageView extends StatelessWidget {
  _LlmMessageView(this.message, {ResponseBuilder? responseBuilder}) {
    this.responseBuilder = responseBuilder ?? _responseBuilder;
  }

  final ChatMessage message;
  late final ResponseBuilder responseBuilder;

  @override
  Widget build(BuildContext context) => Row(
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
                        FatIcons.sparkIcon,
                        color: FatColors.darkIcon,
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: message.text.isEmpty
                          ? const SizedBox(
                              width: 24,
                              child: JumpingDotsProgress(fontSize: 24),
                            )
                          : responseBuilder(context, message.text),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Flexible(flex: 2, child: SizedBox()),
        ],
      );

  Widget _responseBuilder(BuildContext context, String response) =>
      MarkdownBody(data: response);
}
