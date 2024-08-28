// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/llm_provider_interface.dart';
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
            height: 104,
            padding: const EdgeInsets.only(top: 12, bottom: 12, left: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final a in _attachments)
                  _RemoveableAttachment(
                    attachment: a,
                    onRemove: _onRemoveAttachment,
                  ),
              ],
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => SizedBox(
              height: 68,
              child: Row(
                children: [
                  _AttachmentActionBar(onAttachment: _onAttachment),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 52,
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
  Widget build(BuildContext context) => Container(
        decoration: _expanded
            ? BoxDecoration(
                color: buttonBackground1Color,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        child: OverflowBar(
          children: _expanded
              ? [
                  _CircleButton(
                    onPressed: _onToggleMenu,
                    icon: Icons.close,
                    color: buttonBackground2Color,
                  ),
                  if (_canCamera)
                    _CircleButton(
                      onPressed: _onCamera,
                      icon: Icons.camera_alt,
                    ),
                  _CircleButton(
                    onPressed: _onGallery,
                    icon: Icons.image,
                  ),
                  _CircleButton(
                    onPressed: _onFile,
                    icon: Icons.attach_file,
                  ),
                ]
              : [
                  _CircleButton(
                    onPressed: _onToggleMenu,
                    icon: Icons.add,
                  ),
                ],
        ),
      );

  void _onToggleMenu() => setState(() => _expanded = !_expanded);
  Future<void> _onCamera() => _pickImage(ImageSource.camera);
  Future<void> _onGallery() => _pickImage(ImageSource.gallery);

  Future<void> _pickImage(ImageSource source) async {
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

  Future<void> _onFile() async {
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    this.onPressed,
    this.color = iconColor,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _enabled ? color : disabledButtonColor,
          ),
          child: Icon(
            icon,
            color: _enabled ? backgroundColor : iconColor,
            size: size * 0.6,
          ),
        ),
      );

  bool get _enabled => onPressed != null;
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
            child: switch (attachment) {
              (FileAttachment a) => _FileAttachmentView(a),
              (ImageAttachment a) => Image.memory(a.bytes),
              (LinkAttachment _) =>
                throw Exception('Link attachments not supported'),
            },
          ),
          _CircleButton(
            icon: Icons.close,
            // color: placeholderTextColor,
            size: 20,
            onPressed: () => onRemove(attachment),
          ),
        ],
      );
}

class _FileAttachmentView extends StatelessWidget {
  const _FileAttachmentView(this.attachment);
  final FileAttachment attachment;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: unnamedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: placeholderTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.attach_file, color: iconColor, size: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(attachment.name, style: body2TextStyle),
                  Text(
                    attachment.mimeType,
                    style: body2TextStyle.copyWith(
                      color: placeholderTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        _InputState.disabled => const _CircleButton(
            icon: Icons.subdirectory_arrow_right,
          ),
        // enabled Send button
        _InputState.enabled => _CircleButton(
            onPressed: () => onSubmit(text),
            icon: Icons.subdirectory_arrow_right,
          ),
        // enabled Stop button
        _InputState.submitting => _CircleButton(
            onPressed: onCancel,
            icon: Icons.stop,
          ),
      };
}
