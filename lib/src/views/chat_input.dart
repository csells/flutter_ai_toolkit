// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/models/chat_message.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../adaptive_progress_indicator.dart';
import '../adaptive_snack_bar.dart';
import '../fat_icons.dart';
import '../providers/llm_provider_interface.dart';
import '../utility.dart';
import 'attachment_view.dart';
import 'chat_text_field.dart';
import 'circle_button.dart';
import 'fat_colors_styles.dart';
import 'image_preview_dialog.dart';

/// A widget that provides a chat input interface with support for text input,
/// speech-to-text, and attachments.
class ChatInput extends StatefulWidget {
  /// Creates a [ChatInput] widget.
  ///
  /// The [onSendMessage] and [onTranslateStt] parameters are required.
  ///
  /// [initialMessage] can be provided to pre-populate the input field.
  ///
  /// [onCancelMessage] and [onCancelStt] are optional callbacks for cancelling
  /// message submission or speech-to-text translation respectively.
  const ChatInput({
    this.initialMessage,
    required this.onSendMessage,
    required this.onTranslateStt,
    this.onCancelMessage,
    this.onCancelStt,
    super.key,
  }) : assert(
          !(onCancelMessage != null && onCancelStt != null),
          'Cannot be submitting a prompt and doing stt at the same time',
        );

  /// Callback function triggered when a message is sent.
  ///
  /// Takes a [String] for the message text and an [Iterable<Attachment>] for any attachments.
  final void Function(String, Iterable<Attachment>) onSendMessage;

  /// Callback function triggered when speech-to-text translation is requested.
  ///
  /// Takes an [XFile] representing the audio file to be translated.
  final void Function(XFile file) onTranslateStt;

  /// Optional callback function to cancel an ongoing message submission.
  final void Function()? onCancelMessage;

  /// Optional callback function to cancel an ongoing speech-to-text translation.
  final void Function()? onCancelStt;

  /// The initial message to populate the input field, if any.
  final ChatMessage? initialMessage;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

enum _InputState {
  canSubmitPrompt, // has text, submit button enabled
  canCancelPrompt, // submitting text, cancel button enabled
  canStt, // no text, microphone button enabled
  isRecording, // recording speech, stop button enabled
  canCancelStt, // translating speech to text, progress indicator spinning
}

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
  // - the reason we need to request focus in the implementation of the
  //   separate submit/cancel button is because apparently clicking on another
  //   widget when the TextField is focused causes it to lose focus (which makes
  //   sense)
  final _focusNode = FocusNode();

  final _textController = TextEditingController();
  final _waveController = WaveformRecorderController();
  final _attachments = <Attachment>[];
  static const _minInputHeight = 48.0;

  @override
  void didUpdateWidget(covariant ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != null) {
      _textController.text = widget.initialMessage!.text;
      _attachments.clear();
      _attachments.addAll(widget.initialMessage!.attachments);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _waveController.dispose();
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
            valueListenable: _textController,
            builder: (context, value, child) => ListenableBuilder(
              listenable: _waveController,
              builder: (context, child) => Row(
                children: [
                  _AttachmentActionBar(onAttachments: _onAttachments),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: FatColors.outline,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SizedBox(
                          height: _minInputHeight,
                          child: _waveController.isRecording
                              ? WaveformRecorder(
                                  controller: _waveController,
                                  height: _minInputHeight,
                                  onRecordingStopped: _onRecordingStopped,
                                )
                              : ChatTextField(
                                  minLines: 1,
                                  maxLines: 1024,
                                  controller: _textController,
                                  autofocus: true,
                                  focusNode: _focusNode,
                                  // on mobile, pressing enter should add a new
                                  // line. on web+desktop, pressing enter should
                                  // submit the prompt.
                                  textInputAction: isMobile
                                      ? TextInputAction.newline
                                      : TextInputAction.done,
                                  // ignore the user submitting if they can't
                                  // right now; leave the text as is and the field
                                  // focused
                                  onSubmitted:
                                      _inputState == _InputState.canSubmitPrompt
                                          ? (_) => _onSubmitPrompt()
                                          : (_) => _focusNode.requestFocus(),
                                  style: FatStyles.body2,
                                  hintText: "Ask me anything...",
                                  hintStyle: FatStyles.body2.copyWith(
                                    color: FatColors.hintText,
                                  ),
                                  hintPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  _InputButton(
                    inputState: _inputState,
                    onSubmitPrompt: _onSubmitPrompt,
                    onCancelPrompt: _onCancelPrompt,
                    onStartRecording: _onStartRecording,
                    onStopRecording: _onStopRecording,
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  _InputState get _inputState {
    if (_waveController.isRecording) return _InputState.isRecording;
    if (widget.onCancelMessage != null) return _InputState.canCancelPrompt;
    if (widget.onCancelStt != null) return _InputState.canCancelStt;
    if (_textController.text.trim().isEmpty) return _InputState.canStt;
    return _InputState.canSubmitPrompt;
  }

  void _onSubmitPrompt() {
    assert(_inputState == _InputState.canSubmitPrompt);

    // the mobile vkb can still cause a submission even if there is no text
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text, List.from(_attachments));
    _attachments.clear();
    _textController.clear();
    _focusNode.requestFocus();
  }

  void _onCancelPrompt() {
    assert(_inputState == _InputState.canCancelPrompt);
    widget.onCancelMessage!();
    _focusNode.requestFocus();
  }

  Future<void> _onStartRecording() async {
    await _waveController.startRecording();
  }

  Future<void> _onStopRecording() async {
    await _waveController.stopRecording();
  }

  Future<void> _onRecordingStopped() async {
    final file = _waveController.file;

    if (file == null) {
      AdaptiveSnackBar.show(context, 'Unable to record audio');
      return;
    }

    // will come back as initialMessage
    widget.onTranslateStt(file);
  }

  void _onAttachments(Iterable<Attachment> attachments) =>
      setState(() => _attachments.addAll(attachments));

  void _onRemoveAttachment(Attachment attachment) =>
      setState(() => _attachments.remove(attachment));
}

class _InputButton extends StatelessWidget {
  const _InputButton({
    required this.inputState,
    required this.onSubmitPrompt,
    required this.onCancelPrompt,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  final _InputState inputState;
  final void Function() onSubmitPrompt;
  final void Function() onCancelPrompt;
  final void Function() onStartRecording;
  final void Function() onStopRecording;

  @override
  Widget build(BuildContext context) => switch (inputState) {
        _InputState.canSubmitPrompt => CircleButton(
            icon: FatIcons.submit_icon,
            onPressed: onSubmitPrompt,
            iconColor: FatColors.whiteIcon,
            backgroundColor: FatColors.darkButtonBackground,
          ),
        _InputState.canCancelPrompt => CircleButton(
            icon: FatIcons.stop,
            onPressed: onCancelPrompt,
          ),
        _InputState.canStt => CircleButton(
            icon: FatIcons.mic,
            onPressed: onStartRecording,
          ),
        _InputState.isRecording => CircleButton(
            icon: FatIcons.stop,
            onPressed: onStopRecording,
          ),
        _InputState.canCancelStt => const AdaptiveCircularProgressIndicator(),
      };
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

    // _canFile is a temporary work around for this bug:
    // https://github.com/csells/flutter_ai_toolkit/issues/18
    _canFile = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) => _expanded
      ? CircleButtonBar([
          CircleButton(
            onPressed: _onToggleMenu,
            icon: FatIcons.close,
            iconColor: FatColors.whiteIcon,
            backgroundColor: FatColors.greyBackground,
          ),
          if (_canCamera)
            CircleButton(
              onPressed: _onCamera,
              icon: FatIcons.camera_alt,
              iconColor: FatColors.whiteIcon,
              backgroundColor: FatColors.darkButtonBackground,
            ),
          CircleButton(
            onPressed: _onGallery,
            icon: FatIcons.image,
            iconColor: FatColors.whiteIcon,
            backgroundColor: FatColors.darkButtonBackground,
          ),
          if (_canFile)
            CircleButton(
              onPressed: _onFile,
              icon: FatIcons.attach_file,
              iconColor: FatColors.whiteIcon,
              backgroundColor: FatColors.darkButtonBackground,
            ),
        ])
      : CircleButton(
          onPressed: _onToggleMenu,
          icon: FatIcons.add,
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
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick an image: $ex');
      }
    }
  }

  void _onFile() async {
    _onToggleMenu(); // close the menu

    try {
      final files = await openFiles();
      final attachments = await Future.wait(files.map(FileAttachment.fromFile));
      widget.onAttachments(attachments);
    } on Exception catch (ex) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick a file: $ex');
      }
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
                ? () => ImagePreviewDialog.show(
                      context,
                      attachment as ImageFileAttachment,
                    )
                : null,
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              height: 80,
              child: AttachmentView(attachment),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: CircleButton(
              icon: FatIcons.close,
              size: 20,
              onPressed: () => onRemove(attachment),
            ),
          ),
        ],
      );
}
