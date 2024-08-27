// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

import '../providers/llm_provider_interface.dart';

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
            child: _AttachmentsView(_attachments),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => Row(
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
                          borderRadius: BorderRadius.circular(16),
                        ),
                        hintText: "Prompt the LLM",
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _onCamera,
                  icon: const Icon(Icons.camera_alt),
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
    // NOTE: the mobile vkb can still cause a submission even if there is no text
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

  Future<void> _onCamera() async {
    final picker = ImagePicker();
    try {
      final pic = picker.supportsImageSource(ImageSource.camera)
          ? await picker.pickImage(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.gallery);
      if (pic == null) return;
      final mimeType = pic.mimeType ?? lookupMimeType(pic.path);
      if (mimeType == null) throw Exception('Missing mime type');

      final bytes = await pic.readAsBytes();
      setState(() => _attachments.add(DataAttachment(
            mimeType: mimeType,
            bytes: bytes,
          )));
    } on Exception catch (ex) {
      final context = this.context;
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to pick an image: $ex'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _AttachmentsView extends StatelessWidget {
  const _AttachmentsView(List<Attachment> attachments)
      : _attachments = attachments;

  final List<Attachment> _attachments;

  @override
  Widget build(BuildContext context) => ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final a in _attachments)
            Container(
              padding: const EdgeInsets.only(right: 12),
              width: 80,
              height: 80,
              child: _attachmentWidget(a),
            ),
        ],
      );

  Widget _attachmentWidget(Attachment attachment) => switch (attachment) {
        (DataAttachment a) => Image.memory(a.bytes),
        (FileAttachment a) => Image.network(a.url.toString()),
      };
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
        _InputState.disabled => const IconButton(
            onPressed: null,
            icon: Icon(Icons.send),
          ),
        // enabled Send button
        _InputState.enabled => IconButton(
            onPressed: () => onSubmit(text),
            icon: const Icon(Icons.send),
          ),
        // enabled Cancel button
        _InputState.submitting => IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.stop),
          ),
      };
}
