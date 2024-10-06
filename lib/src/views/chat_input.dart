// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/src/models/chat_message.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_platform/universal_platform.dart';

import '../fat_icons.dart';
import '../providers/llm_provider_interface.dart';
import 'attachment_view.dart';
import 'circle_button.dart';
import 'image_preview_dialog.dart';
import 'view_styles.dart';

/// A widget that provides an input field for chat messages with attachment
/// support.
///
/// This widget allows users to enter text messages and add attachments. It also
/// handles the submission of messages and provides a way to cancel the input.
class ChatInput extends StatefulWidget {
  /// Creates a ChatInput widget.
  ///
  /// The [submitting], [onSubmit], and [onCancel] parameters are required.
  const ChatInput({
    required this.submitting,
    required this.onSubmit,
    required this.onCancel,
    this.initialMessage,
    super.key,
  });

  /// Indicates whether a message is currently being submitted.
  final bool submitting;

  /// The initial message to populate the input field, if any.
  final ChatMessage? initialMessage;

  /// Callback function called when a message is submitted.
  ///
  /// It takes two parameters: the message text and a collection of attachments.
  final void Function(String, Iterable<Attachment>) onSubmit;

  /// Callback function called when the input is cancelled.
  final void Function() onCancel;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

enum _InputState { disabled, enabled, submitting }

class _ChatInputState extends State<ChatInput> {
  // Notes on the way focus works in this widget:
  // - we use a focus node to request focus when the input is submitted or
  //   cancelled
  // - we leave the text field enabled so that it never artifically loses focus
  //   (you can't have focus on a disabled widget)
  // - this means we're not taking back focus after a submission or a
  //   cancellation is complete from another widget in the app that might have
  //   it, e.g. if we attempted to take back focus in didUpdateWidget
  // - this also means that we don't need any complicated logic to request focus
  //   in didUpdateWidget only the first time after a submission or cancellation
  //   that would be required to keep from stealing focus from other widgets in
  //   the app
  // - also, if the user is submitting and they press Enter while inside the
  //   text field, we want to put the focus back in the text field but otherwise
  //   ignore the Enter key; it doesn't make sense for Enter to cancel - they
  //   can use the Cancel button for that.
  // - the reason we need to request focus in the onSubmitted function of the
  //   TextField is because apparently it gives up focus as part of its
  //   implementation somehow (just how is something to discover)
  // - the research we need to request focus in the implementation of the
  //   separate submit/cancel button is because apparently clicking on another
  //   widget when the TextField is focused causes it to lose focus (which makes
  //   sense)
  final _focusNode = FocusNode();

  final _controller = TextEditingController();
  final _attachments = <Attachment>[];
  final _isMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;

  final _border = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: outlineColor),
    borderRadius: BorderRadius.circular(24),
  );

  @override
  void didUpdateWidget(covariant ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != null) {
      _controller.text = widget.initialMessage!.text;
      _attachments.addAll(widget.initialMessage!.attachments);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            height: _attachments.isNotEmpty ? 104 : 0,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
            child: _attachments.isNotEmpty
                ? ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final a in _attachments)
                        _RemovableAttachment(
                          attachment: a,
                          onRemove: _onRemoveAttachment,
                        ),
                    ],
                  )
                : const SizedBox(),
          ),
          const Gap(6),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => Row(
              children: [
                _AttachmentActionBar(onAttachments: _onAttachments),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      minLines: 1,
                      maxLines: 1024,
                      controller: _controller,
                      autofocus: true,
                      focusNode: _focusNode,
                      // on mobile, pressing enter should add a new line
                      // on web+desktop, pressing enter should submit the prompt
                      textInputAction: _isMobile
                          ? TextInputAction.newline
                          : TextInputAction.done,
                      onSubmitted: _inputState == _InputState.submitting
                          ? (_) => _focusNode.requestFocus()
                          : _onSubmit,
                      style: body2TextStyle,
                      decoration: InputDecoration(
                        // need to set all four xxxBorder args (but not
                        // border itself) to override Material styles
                        errorBorder: _border,
                        focusedBorder: _border,
                        enabledBorder: _border,
                        disabledBorder: _border.copyWith(
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        hintText: "Ask me anything...",
                        hintStyle: body2TextStyle.copyWith(
                          color: placeholderTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                _SubmitButton(
                  text: _controller.text,
                  inputState: _inputState,
                  onSubmit: _onSubmit,
                  onCancel: _onCancel,
                ),
              ],
            ),
          ),
        ],
      );

  _InputState get _inputState {
    if (widget.submitting) return _InputState.submitting;
    final text = _controller.text.trim();
    if (text.isNotEmpty) return _InputState.enabled;
    assert(!widget.submitting && text.isEmpty);
    return _InputState.disabled;
  }

  void _onSubmit(String prompt) {
    // the mobile vkb can still cause a submission even if there is no text
    final text = prompt.trim();
    if (text.isEmpty) return;

    assert(_inputState == _InputState.enabled);
    widget.onSubmit(text, List.from(_attachments));
    _attachments.clear();
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onCancel() {
    assert(_inputState == _InputState.submitting);
    widget.onCancel();
    _focusNode.requestFocus();
  }

  void _onAttachments(Iterable<Attachment> attachments) =>
      setState(() => _attachments.addAll(attachments));

  void _onRemoveAttachment(Attachment attachment) =>
      setState(() => _attachments.remove(attachment));
}

class _AttachmentActionBar extends StatefulWidget {
  const _AttachmentActionBar({required this.onAttachments});
  final Function(Iterable<Attachment> attachments) onAttachments;

  @override
  State<_AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<_AttachmentActionBar> {
  var _expanded = false;
  late final bool _canCamera;
  late final bool _canFile;

  @override
  void initState() {
    super.initState();
    _canCamera = ImagePicker().supportsImageSource(ImageSource.camera);

    // _canFile is a work around for this bug:
    // https://github.com/csells/flutter_ai_toolkit/issues/18
    _canFile = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) => _expanded
      ? CircleButtonBar([
          CircleButton(
            onPressed: _onToggleMenu,
            icon: Icons.close,
            color: buttonBackground2Color,
          ),
          if (_canCamera)
            CircleButton(
              onPressed: _onCamera,
              icon: Icons.camera_alt,
            ),
          CircleButton(
            onPressed: _onGallery,
            icon: Icons.image,
          ),
          if (_canFile)
            CircleButton(
              onPressed: _onFile,
              icon: Icons.attach_file,
            ),
        ])
      : CircleButton(
          onPressed: _onToggleMenu,
          icon: Icons.add,
        );

  void _onToggleMenu() => setState(() => _expanded = !_expanded);
  void _onCamera() => _pickImage(ImageSource.camera);
  void _onGallery() => _pickImage(ImageSource.gallery);

  void _pickImage(ImageSource source) async {
    _onToggleMenu(); // close the menu

    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final pics = await picker.pickMultiImage();
        final attachments = await Future.wait(pics.map(
          ImageFileAttachment.fromFile,
        ));
        widget.onAttachments(attachments);
      } else {
        final pic = await picker.pickImage(source: source);
        if (pic == null) return;
        widget.onAttachments([await ImageFileAttachment.fromFile(pic)]);
      }
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick an image: $ex')),
      );
    }
  }

  void _onFile() async {
    _onToggleMenu(); // close the menu

    try {
      final files = await openFiles();
      final attachments = await Future.wait(files.map(FileAttachment.fromFile));
      widget.onAttachments(attachments);
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick a file: $ex')),
      );
    }
  }
}

class _RemovableAttachment extends StatelessWidget {
  const _RemovableAttachment({
    required this.attachment,
    required this.onRemove,
  });

  final Attachment attachment;
  final Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GestureDetector(
            onTap: attachment is ImageFileAttachment
                ? () =>
                    ImagePreviewDialog(attachment as ImageFileAttachment).show(
                      context,
                    )
                : null,
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              height: 80,
              child: AttachmentView(attachment),
            ),
          ),
          CircleButton(
            icon: Icons.close,
            // color: placeholderTextColor,
            size: 20,
            onPressed: () => onRemove(attachment),
          ),
        ],
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.text,
    required this.inputState,
    required this.onSubmit,
    required this.onCancel,
  });

  final String text;
  final _InputState inputState;
  final void Function(String) onSubmit;
  final void Function() onCancel;

  @override
  Widget build(BuildContext context) => switch (inputState) {
        // disabled Submit button
        _InputState.disabled => const CircleButton(
            icon: FatIcons.submitIcon,
          ),
        // enabled Submit button
        _InputState.enabled => CircleButton(
            onPressed: () => onSubmit(text),
            icon: FatIcons.submitIcon,
          ),
        // enabled Cancel button
        _InputState.submitting => CircleButton(
            onPressed: onCancel,
            icon: Icons.stop,
          ),
      };
}
