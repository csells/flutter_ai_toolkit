// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/llm_provider_interface.dart';
import 'attachment_view.dart';
import 'circle_button.dart';
import 'view_styles.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.submitting,
    required this.onSubmit,
    required this.onCancel,
    this.initialInput,
    super.key,
  });

  // TODO: hoist this up to the top-level state; should not be passing it in!
  final bool submitting;

  final String? initialInput;
  final void Function(String, Iterable<Attachment>) onSubmit;
  final void Function() onCancel;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

enum _InputState { disabled, enabled, submitting }

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _attachments = <Attachment>[];

  final _border = OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: outlineColor),
    borderRadius: BorderRadius.circular(24),
  );

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
                        _RemoveableAttachment(
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
                _AttachmentActionBar(onAttachment: _onAttachment),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      enabled: _inputState != _InputState.submitting,
                      minLines: 1,
                      maxLines: 1024,
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (value) => _onSubmit(value),
                      style: body2TextStyle,
                      decoration: InputDecoration(
                        // need to set all four xxxBorder args (but not
                        // border itself) override Material styles
                        errorBorder: _border,
                        focusedBorder: _border,
                        enabledBorder: _border,
                        disabledBorder: _border,
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
    if (_controller.text.isNotEmpty) return _InputState.enabled;
    assert(!widget.submitting && _controller.text.isEmpty);
    return _InputState.disabled;
  }

  void _onSubmit(String prompt) {
    // the mobile vkb can still cause a submission even if there is no text
    if (_controller.text.isEmpty) return;

    assert(_inputState == _InputState.enabled);
    widget.onSubmit(prompt, List.from(_attachments));
    _attachments.clear();
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _onCancel() {
    assert(_inputState == _InputState.submitting);
    widget.onCancel();
    _controller.clear();
    _attachments.clear();
    _focusNode.requestFocus();
  }

  void _onAttachment(Attachment attachment) =>
      setState(() => _attachments.add(attachment));

  _onRemoveAttachment(Attachment attachment) =>
      setState(() => _attachments.remove(attachment));
}

class _AttachmentActionBar extends StatefulWidget {
  const _AttachmentActionBar({required this.onAttachment});
  final Function(Attachment attachment) onAttachment;

  @override
  State<_AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<_AttachmentActionBar> {
  var _expanded = false;
  late final bool _canCamera;

  @override
  void initState() {
    super.initState();
    _canCamera = ImagePicker().supportsImageSource(ImageSource.camera);
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
      final pic = await picker.pickImage(source: source);
      if (pic == null) return;
      widget.onAttachment(await ImageAttachment.fromFile(pic));
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
      final file = await openFile();
      if (file == null) return;
      widget.onAttachment(await FileAttachment.fromFile(file));
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to pick a file: $ex')),
      );
    }
  }
}

class _RemoveableAttachment extends StatelessWidget {
  const _RemoveableAttachment({
    required this.attachment,
    required this.onRemove,
  });

  final Attachment attachment;
  final Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            height: 80,
            child: AttachmentView(attachment),
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
        // disabled Send button
        _InputState.disabled => const CircleButton(
            icon: Icons.subdirectory_arrow_right,
          ),
        // enabled Send button
        _InputState.enabled => CircleButton(
            onPressed: () => onSubmit(text),
            icon: Icons.subdirectory_arrow_right,
          ),
        // enabled Stop button
        _InputState.submitting => CircleButton(
            onPressed: onCancel,
            icon: Icons.stop,
          ),
      };
}
