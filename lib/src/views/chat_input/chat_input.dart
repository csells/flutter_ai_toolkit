// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import '../../chat_view_model/chat_view_model_client.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../providers/interface/attachments.dart';
import '../../providers/interface/chat_message.dart';
import '../../styles/action_button_style.dart';
import '../../styles/chat_input_style.dart';
import '../../styles/llm_chat_view_style.dart';
import '../../styles/toolkit_text_styles.dart';
import '../../utility.dart';
import '../action_button/action_button.dart';
import '../chat_text_field.dart';
import 'attachments_action_bar.dart';
import 'attachments_view.dart';
import 'input_button.dart';
import 'input_state.dart';

/// A widget that provides a chat input interface with support for text input,
/// speech-to-text, and attachments.
@immutable
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
    required this.onSendMessage,
    required this.onTranslateStt,
    this.initialMessage,
    this.onCancelEdit,
    this.onCancelMessage,
    this.onCancelStt,
    super.key,
  })  : assert(
          !(onCancelMessage != null && onCancelStt != null),
          'Cannot be submitting a prompt and doing stt at the same time',
        ),
        assert(
          !(onCancelEdit != null && initialMessage == null),
          'Cannot cancel edit of a message if no initial message is provided',
        );

  /// Callback function triggered when a message is sent.
  ///
  /// Takes a [String] for the message text and an [`Iterable<Attachment>`] for
  /// any attachments.
  final void Function(String, Iterable<Attachment>) onSendMessage;

  /// Callback function triggered when speech-to-text translation is requested.
  ///
  /// Takes an [XFile] representing the audio file to be translated.
  final void Function(XFile file) onTranslateStt;

  /// The initial message to populate the input field, if any.
  final ChatMessage? initialMessage;

  /// Optional callback function to cancel an ongoing edit of a message, passed
  /// via [initialMessage], that has already received a response. To allow for a
  /// non-destructive edit, if the user cancels the editing of the message, we
  /// call [onCancelEdit] to revert to the original message and response.
  final void Function()? onCancelEdit;

  /// Optional callback function to cancel an ongoing message submission.
  final void Function()? onCancelMessage;

  /// Optional callback function to cancel an ongoing speech-to-text
  /// translation.
  final void Function()? onCancelStt;

  @override
  State<ChatInput> createState() => _ChatInputState();
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
  // - the reason we need to request focus in the implementation of the separate
  //   submit/cancel button is because  clicking on another widget when the
  //   TextField is focused causes it to lose focus (as it should)
  final _focusNode = FocusNode();

  final _textController = TextEditingController();
  final _waveController = WaveformRecorderController();
  final _attachments = <Attachment>[];
  static const _minInputHeight = 48.0;
  static const _maxInputHeight = 144.0;

  @override
  void didUpdateWidget(covariant ChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != null) {
      _textController.text = widget.initialMessage!.text ?? '';
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
  Widget build(BuildContext context) => ChatViewModelClient(
        builder: (context, viewModel, child) {
          final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
          final inputStyle = ChatInputStyle.resolve(
            viewModel.style?.chatInputStyle,
          );

          return Container(
            color: inputStyle.backgroundColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AttachmentsView(
                  attachments: _attachments,
                  onRemove: onRemoveAttachment,
                ),
                if (_attachments.isNotEmpty) const Gap(6),
                ValueListenableBuilder(
                  valueListenable: _textController,
                  builder: (context, value, child) => ListenableBuilder(
                    listenable: _waveController,
                    builder: (context, child) => Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: AttachmentActionBar(
                            onAttachments: onAttachments,
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: widget.onCancelEdit != null ? 24 : 8,
                                  bottom: 8,
                                ),
                                child: DecoratedBox(
                                  decoration: inputStyle.decoration!,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: _minInputHeight,
                                      maxHeight: _maxInputHeight,
                                    ),
                                    child: _waveController.isRecording
                                        ? WaveformRecorder(
                                            controller: _waveController,
                                            height: _minInputHeight,
                                            onRecordingStopped:
                                                onRecordingStopped,
                                          )
                                        : SingleChildScrollView(
                                            child: ChatTextField(
                                              minLines: 1,
                                              maxLines: 1024,
                                              controller: _textController,
                                              autofocus: true,
                                              focusNode: _focusNode,
                                              textInputAction: isMobile
                                                  ? TextInputAction.newline
                                                  : TextInputAction.done,
                                              onSubmitted: _inputState ==
                                                      InputState.canSubmitPrompt
                                                  ? (_) => onSubmitPrompt()
                                                  : (_) =>
                                                      _focusNode.requestFocus(),
                                              style: inputStyle.textStyle!,
                                              hintText: inputStyle.hintText!,
                                              hintStyle: inputStyle.hintStyle!,
                                              hintPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: widget.onCancelEdit != null
                                    ? _EditingIndicator(
                                        onCancelEdit: widget.onCancelEdit!,
                                        cancelButtonStyle:
                                            chatStyle.cancelButtonStyle!,
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: InputButton(
                            inputState: _inputState,
                            chatStyle: chatStyle,
                            onSubmitPrompt: onSubmitPrompt,
                            onCancelPrompt: onCancelPrompt,
                            onStartRecording: onStartRecording,
                            onStopRecording: onStopRecording,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

  InputState get _inputState {
    if (_waveController.isRecording) return InputState.isRecording;
    if (widget.onCancelMessage != null) return InputState.canCancelPrompt;
    if (widget.onCancelStt != null) return InputState.canCancelStt;
    if (_textController.text.trim().isEmpty) return InputState.canStt;
    return InputState.canSubmitPrompt;
  }

  void onSubmitPrompt() {
    assert(_inputState == InputState.canSubmitPrompt);

    // the mobile vkb can still cause a submission even if there is no text
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text, List.from(_attachments));
    _attachments.clear();
    _textController.clear();
    _focusNode.requestFocus();
  }

  void onCancelPrompt() {
    assert(_inputState == InputState.canCancelPrompt);
    widget.onCancelMessage!();
    _focusNode.requestFocus();
  }

  Future<void> onStartRecording() async {
    await _waveController.startRecording();
  }

  Future<void> onStopRecording() async {
    await _waveController.stopRecording();
  }

  Future<void> onRecordingStopped() async {
    final file = _waveController.file;

    if (file == null) {
      AdaptiveSnackBar.show(context, 'Unable to record audio');
      return;
    }

    // will come back as initialMessage
    widget.onTranslateStt(file);
  }

  void onAttachments(Iterable<Attachment> attachments) =>
      setState(() => _attachments.addAll(attachments));

  void onRemoveAttachment(Attachment attachment) =>
      setState(() => _attachments.remove(attachment));
}

class _EditingIndicator extends StatelessWidget {
  const _EditingIndicator({
    required this.onCancelEdit,
    required this.cancelButtonStyle,
  });

  final VoidCallback onCancelEdit;
  final ActionButtonStyle cancelButtonStyle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          right: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Editing',
              style: ToolkitTextStyles.label.copyWith(
                color: invertColor(cancelButtonStyle.iconColor),
              ),
            ),
            const Gap(6),
            ActionButton(
              onPressed: onCancelEdit,
              style: cancelButtonStyle,
              size: 16,
            ),
          ],
        ),
      );
}
