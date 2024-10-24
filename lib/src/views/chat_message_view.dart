// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/views/circle_button.dart';
import 'package:flutter_ai_toolkit/src/views/fat_colors_styles.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';

import '../adaptive_snack_bar.dart';
import '../fat_icons.dart';
import '../models/chat_message.dart';
import '../utility.dart';
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
    required this.llmIcon,
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

  /// An icon to display for the LLM.
  final IconData llmIcon;

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
                    llmIcon: widget.llmIcon,
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
                              icon: FatIcons.edit,
                              iconColor: FatColors.whiteIcon,
                              backgroundColor: FatColors.darkButtonBackground,
                            ),
                          CircleButton(
                            onPressed: _onCopy,
                            icon: FatIcons.content_copy,
                            iconColor: FatColors.whiteIcon,
                            backgroundColor: FatColors.darkButtonBackground,
                          ),
                          CircleButton(
                            onPressed: _onSelect,
                            icon: FatIcons.close,
                            iconColor: FatColors.whiteIcon,
                            backgroundColor: FatColors.greyBackground,
                          ),
                        ]
                      : [
                          CircleButton(
                            onPressed: _onSelect,
                            icon: FatIcons.close,
                            backgroundColor: FatColors.greyBackground,
                          ),
                          CircleButton(
                            onPressed: _onCopy,
                            icon: FatIcons.content_copy,
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

  Future<void> _onCopy() async {
    widget.onSelected?.call(false);
    await Clipboard.setData(ClipboardData(text: widget.message.text));

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      AdaptiveSnackBar.show(context, 'Message copied to clipboard');
    }
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
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                        bottom: 12,
                      ),
                      child: Text(
                        message.text,
                        style: FatStyles.body1,
                      ),
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
  _LlmMessageView(
    this.message, {
    required this.llmIcon,
    ResponseBuilder? responseBuilder,
  }) {
    this.responseBuilder = responseBuilder ?? _responseBuilder;
  }

  final ChatMessage message;
  final IconData llmIcon;
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
                      child: Icon(
                        llmIcon,
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

  // using SelectionArea so that it works with Cupertino as well as Material,
  // even though SelectionArea is defined as a Material widget. since it doesn't
  // require running inside a MaterialApp, we're good.
  Widget _responseBuilder(BuildContext context, String response) => isMobile
      ? _Markdown(response)
      : Localizations(
          locale: Localizations.localeOf(context),
          delegates: const [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
          child: SelectionArea(
            child: _Markdown(response),
          ),
        );
}

class _Markdown extends StatelessWidget {
  const _Markdown(this.response);
  final String response;

  @override
  Widget build(BuildContext context) => MarkdownBody(
        data: response,
        selectable: false,
        styleSheet: MarkdownStyleSheet(
          a: FatStyles.body1,
          blockquote: FatStyles.body1,
          checkbox: FatStyles.body1,
          code: FatStyles.code,
          del: FatStyles.body1,
          em: FatStyles.body1,
          h1: FatStyles.heading1,
          h2: FatStyles.heading2,
          h3: FatStyles.body1,
          h4: FatStyles.body1,
          h5: FatStyles.body1,
          h6: FatStyles.body1,
          listBullet: FatStyles.body1,
          img: FatStyles.body1,
          strong: FatStyles.body1,
          p: FatStyles.body1,
          tableBody: FatStyles.body1,
          tableHead: FatStyles.body1,
        ),
      );
}
