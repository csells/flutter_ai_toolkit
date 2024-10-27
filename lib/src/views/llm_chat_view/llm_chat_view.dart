// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';

import '../../../flutter_ai_toolkit.dart';
import '../../dialogs/adaptive_dialog.dart';
import '../../dialogs/adaptive_dialog_action.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../llm_exception.dart';
import '../../models/chat_view_model/chat_view_model.dart';
import '../../models/chat_view_model/chat_view_model_provider.dart';
import '../../platform_helper/platform_helper_io.dart';
import '../../providers/forwarding_provider.dart';
import '../chat_history_view.dart';
import '../chat_input/chat_input.dart';
import '../response_builder.dart';
import 'llm_response.dart';

/// A widget that displays a chat interface for interacting with an LLM
/// (Language Learning Model).
///
/// This widget creates a chat view where users can send messages to an LLM and
/// receive responses. It handles the display of the chat transcript and the
/// input mechanism for sending new messages.
///
/// The [provider] parameter is required and specifies the LLM provider to use
/// for generating responses.
/// A widget that displays a chat interface for interacting with an LLM
/// (Language Learning Model).
///
/// This widget creates a chat view where users can send messages to an LLM and
/// receive responses. It handles the display of the chat transcript and the
/// input mechanism for sending new messages.
///
/// The [provider] parameter is required and specifies the LLM provider to use
/// for generating responses.
///
/// The [responseBuilder] parameter is an optional function that allows
/// customizing how responses are displayed in the chat interface.
///
/// The [messageSender] parameter is an optional function that allows
/// preprocessing of messages before they are sent to the LLM provider.
/// This can be used for tasks such as prompt engineering or adding context
/// to the conversation. If provided, this function will be called for each
/// message before it is sent to the LLM provider. It should return a
/// Stream<String> containing the processed message.
///
/// The [welcomeMessage] parameter is an optional welcome message to display
/// when the chat view is first shown. If null, no welcome message is displayed.
class LlmChatView extends StatefulWidget {
  /// Creates an LlmChatView.
  ///
  /// The [provider] parameter must not be null.
  LlmChatView({
    required LlmProvider provider,
    ResponseBuilder? responseBuilder,
    LlmStreamGenerator? messageSender,
    String? welcomeMessage,
    LlmChatViewStyle? style,
    List<LlmChatMessage>? transcript,
    super.key,
  }) : viewModel = ChatViewModel(
          provider: messageSender == null
              ? provider
              : ForwardingProvider(
                  provider: provider,
                  messageSender: messageSender,
                ),
          transcript: transcript ?? List<LlmChatMessage>.empty(growable: true),
          responseBuilder: responseBuilder,
          welcomeMessage: welcomeMessage,
          style: style,
        );

  /// The view model containing the chat state and configuration.
  ///
  /// This [ChatViewModel] instance holds the LLM provider, transcript,
  /// response builder, welcome message, and LLM icon for the chat interface.
  /// It encapsulates the core data and functionality needed for the chat view.
  final ChatViewModel viewModel;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmChatViewState extends State<LlmChatView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  LlmResponse? _pendingPromptResponse;
  LlmChatMessage? _initialMessage;
  LlmResponse? _pendingSttResponse;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel.welcomeMessage != null) {
      widget.viewModel.transcript.add(
        LlmChatMessage.llmWelcome(widget.viewModel.welcomeMessage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for AutomaticKeepAliveClientMixin

    final chatStyle = LlmChatViewStyle.resolve(widget.viewModel.style);
    return ChatViewModelProvider(
      viewModel: widget.viewModel,
      child: Container(
        color: chatStyle.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: ChatHistoryView(
                onEditMessage:
                    _pendingPromptResponse == null ? _onEditMessage : null,
              ),
            ),
            ChatInput(
              initialMessage: _initialMessage,
              onSendMessage: _onSendMessage,
              onCancelMessage:
                  _pendingPromptResponse == null ? null : _onCancelMessage,
              onTranslateStt: _onTranslateStt,
              onCancelStt: _pendingSttResponse == null ? null : _onCancelStt,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSendMessage(
    String prompt,
    Iterable<Attachment> attachments,
  ) async {
    _initialMessage = null;

    final userMessage = LlmChatMessage.user(prompt, attachments);
    final llmMessage = LlmChatMessage.llm();

    widget.viewModel.transcript.addAll([userMessage, llmMessage]);

    _pendingPromptResponse = LlmResponse(
      stream: widget.viewModel.provider.sendMessageStream(
        prompt,
        attachments: attachments,
      ),
      message: llmMessage,
      onDone: _onPromptDone,
    );

    setState(() {});
  }

  void _onPromptDone(LlmException? error) {
    setState(() => _pendingPromptResponse = null);
    _showLlmException(error);
  }

  void _onCancelMessage() => _pendingPromptResponse?.cancel();

  void _onEditMessage(LlmChatMessage message) {
    assert(_pendingPromptResponse == null);

    // remove the last llm message
    assert(widget.viewModel.transcript.last.origin.isLlm);
    widget.viewModel.transcript.removeLast();

    // remove the last user message
    assert(widget.viewModel.transcript.last.origin.isUser);
    final userMessage = widget.viewModel.transcript.removeLast();

    // set the text of the controller to the last userMessage
    setState(() => _initialMessage = userMessage);
  }

  Future<void> _onTranslateStt(XFile file) async {
    _initialMessage = null;

    // use the LLM to translate the attached audio to text
    final prompt =
        'translate the attached audio to text; provide the result of that '
        'translation as just the text of the translation itself. be careful to '
        'separate the background audio from the foreground audio and only '
        'provide the result of translating the foreground audio.';
    final attachments = [await FileAttachment.fromFile(file)];

    _pendingSttResponse = LlmResponse(
      stream: widget.viewModel.provider.generateStream(
        prompt,
        attachments: attachments,
      ),
      message: LlmChatMessage.llm(),
      onDone: _onSttDone,
    );

    // delete the file when we're done
    await PlatformHelper.deleteFile(file);

    setState(() {});
  }

  void _onSttDone(LlmException? error) {
    assert(_pendingSttResponse != null);
    setState(() {
      _initialMessage = _pendingSttResponse!.message;
      _pendingSttResponse = null;
    });

    _showLlmException(error);
  }

  void _onCancelStt() => _pendingSttResponse?.cancel();

  void _showLlmException(LlmException? error) {
    if (error == null) return;

    switch (error) {
      case LlmCancelException():
        AdaptiveSnackBar.show(context, 'LLM operation canceled by user');
        break;
      case LlmFailureException():
      case LlmException():
        AdaptiveAlertDialog.show(
          context: context,
          content: Text(error.toString()),
          actions: [
            AdaptiveDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
        break;
    }
  }
}
