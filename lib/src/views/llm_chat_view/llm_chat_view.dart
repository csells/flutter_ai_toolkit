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
import '../../chat_view_model/chat_view_model.dart';
import '../../chat_view_model/chat_view_model_provider.dart';
import '../../platform_helper/platform_helper.dart' as ph;
import '../../providers/implementations/forwarding_provider.dart';
import '../../providers/interface/attachments.dart';
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
    LlmChatViewStyle? style,
    ResponseBuilder? responseBuilder,
    LlmStreamGenerator? messageSender,
    super.key,
  }) : viewModel = ChatViewModel(
          provider: messageSender == null
              ? provider
              : ForwardingProvider(
                  provider: provider,
                  messageSender: messageSender,
                ),
          responseBuilder: responseBuilder,
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
  ChatMessage? _initialMessage;
  LlmResponse? _pendingSttResponse;

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

    _pendingPromptResponse = LlmResponse(
      // TODO: once ForwardingProvider is gone, use messageSender here instance
      stream: widget.viewModel.provider.sendMessageStream(
        prompt,
        attachments: attachments,
      ),
      onUpdate: (_) => setState(() {}),
      onDone: _onPromptDone,
    );

    setState(() {});
  }

  void _onPromptDone(LlmException? error) {
    setState(() => _pendingPromptResponse = null);
    _showLlmException(error);
  }

  void _onCancelMessage() => _pendingPromptResponse?.cancel();

  void _onEditMessage(ChatMessage message) {
    assert(_pendingPromptResponse == null);

    // TODO: support this in the provider
    // // remove the last llm message
    // assert(widget.viewModel.transcript.last.origin.isLlm);
    // widget.viewModel.transcript.removeLast();

    // // remove the last user message
    // assert(widget.viewModel.transcript.last.origin.isUser);
    // final userMessage = widget.viewModel.transcript.removeLast();

    // set the text of the controller to the last userMessage
    // setState(() => _initialMessage = userMessage);
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

    String response = '';
    _pendingSttResponse = LlmResponse(
      stream: widget.viewModel.provider.generateStream(
        prompt,
        attachments: attachments,
      ),
      onUpdate: (text) => setState(() => response += text),
      onDone: (error) async {
        _onSttDone(error, response, file);
      },
    );

    setState(() {});
  }

  void _onSttDone(LlmException? error, String response, XFile file) async {
    assert(_pendingSttResponse != null);
    setState(() {
      _initialMessage = ChatMessage.llm()..append(response);
      _pendingSttResponse = null;
    });

    // delete the file now that the LLM has translated it
    ph.deleteFile(file);

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
