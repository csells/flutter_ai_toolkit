// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';

import '../../chat_view_model/chat_view_model.dart';
import '../../chat_view_model/chat_view_model_provider.dart';
import '../../dialogs/adaptive_dialog.dart';
import '../../dialogs/adaptive_dialog_action.dart';
import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../llm_chat_view_controller.dart';
import '../../llm_exception.dart';
import '../../platform_helper/platform_helper.dart' as ph;
import '../../providers/interface/attachments.dart';
import '../../providers/interface/chat_message.dart';
import '../../providers/interface/llm_provider.dart';
import '../../styles/llm_chat_view_style.dart';
import '../chat_history_view.dart';
import '../chat_input/chat_input.dart';
import '../chat_input/chat_suggestion_view.dart';
import '../response_builder.dart';
import 'llm_response.dart';

/// A widget that displays a chat interface for interacting with an LLM
/// (Language Model).
///
/// This widget provides a complete chat interface, including a message history
/// view and an input area for sending new messages. It can be configured with
/// either an [LlmProvider] or an [LlmChatViewController] to manage the chat
/// interactions.
///
/// Example usage:
/// ```dart
/// LlmChatView(
///   provider: MyLlmProvider(),
///   style: LlmChatViewStyle(
///     backgroundColor: Colors.white,
///     // ... other style properties
///   ),
/// )
/// ```
@immutable
class LlmChatView extends StatefulWidget {
  /// Creates an [LlmChatView] widget.
  ///
  /// You must provide either a [provider] or a [controller], but not both. If
  /// [provider] is provided, a new [LlmChatViewController] will be created
  /// internally.
  ///
  /// The [style] parameter can be used to customize the appearance of the chat
  /// view. The [responseBuilder] allows custom rendering of chat responses.
  ///
  /// Throws an [ArgumentError] if both [provider] and [controller] are
  /// provided, or if neither is provided.
  LlmChatView({
    LlmProvider? provider,
    LlmChatViewController? controller,
    LlmChatViewStyle? style,
    ResponseBuilder? responseBuilder,
    this.suggestions = const [],
    super.key,
  }) {
    if (provider != null && controller != null) {
      throw ArgumentError('Cannot provide both provider and controller');
    }

    if (provider == null && controller == null) {
      throw ArgumentError('Must provide either provider or controller');
    }

    viewModel = ChatViewModel(
      controller: controller ?? LlmChatViewController(provider: provider!),
      responseBuilder: responseBuilder,
      style: style,
    );
  }

  /// The list of suggestions to display in the chat interface.
  ///
  /// This list contains predefined suggestions that can be shown to the user
  /// when the chat history is empty. The user can select any of these
  /// suggestions to quickly start a conversation with the LLM.
  final List<String> suggestions;

  /// The view model containing the chat state and configuration.
  ///
  /// This [ChatViewModel] instance holds the LLM provider, transcript,
  /// response builder, welcome message, and LLM icon for the chat interface.
  /// It encapsulates the core data and functionality needed for the chat view.
  late final ChatViewModel viewModel;

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
              child: Stack(
                children: [
                  ChatHistoryView(
                    onEditMessage:
                        _pendingPromptResponse == null ? _onEditMessage : null,
                  ),
                  if (widget.suggestions.isNotEmpty &&
                      widget.viewModel.controller.history.isEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ChatSuggestionsView(
                        suggestions: widget.suggestions,
                        onSelectSuggestion: _onSelectSuggestion,
                      ),
                    ),
                ],
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
      stream: widget.viewModel.controller.sendMessageStream(
        prompt,
        attachments: attachments,
      ),
      // update during the streaming response input; the controller will notify
      // listeners only when the response is complete
      onUpdate: (_) => setState(() {}),
      onDone: _onPromptDone,
    );

    setState(() {});
  }

  void _onPromptDone(LlmException? error) {
    setState(() => _pendingPromptResponse = null);
    unawaited(_showLlmException(error));
  }

  void _onCancelMessage() => _pendingPromptResponse?.cancel();

  void _onEditMessage(ChatMessage message) {
    assert(_pendingPromptResponse == null);

    // remove the last llm message
    final history = widget.viewModel.controller.history.toList();
    assert(history.last.origin.isLlm);
    history.removeLast();

    // remove the last user message
    assert(history.last.origin.isUser);
    final userMessage = history.removeLast();

    // set the history to the new history
    widget.viewModel.controller.history = history;

    //set the text of the controller to the last userMessage to provide initial
    //prompt and attachments for the user to edit
    setState(() => _initialMessage = userMessage);
  }

  Future<void> _onTranslateStt(XFile file) async {
    _initialMessage = null;

    // use the LLM to translate the attached audio to text
    const prompt =
        'translate the attached audio to text; provide the result of that '
        'translation as just the text of the translation itself. be careful to '
        'separate the background audio from the foreground audio and only '
        'provide the result of translating the foreground audio.';
    final attachments = [await FileAttachment.fromFile(file)];

    var response = '';
    _pendingSttResponse = LlmResponse(
      stream: widget.viewModel.controller.generateStream(
        prompt,
        attachments: attachments,
      ),
      onUpdate: (text) => response += text,
      onDone: (error) async => _onSttDone(error, response, file),
    );

    setState(() {});
  }

  Future<void> _onSttDone(
      LlmException? error, String response, XFile file) async {
    assert(_pendingSttResponse != null);
    setState(() {
      _initialMessage = ChatMessage.user(response, []);
      _pendingSttResponse = null;
    });

    // delete the file now that the LLM has translated it
    unawaited(ph.deleteFile(file));

    unawaited(_showLlmException(error));
  }

  void _onCancelStt() => _pendingSttResponse?.cancel();

  Future<void> _showLlmException(LlmException? error) async {
    if (error == null) return;

    switch (error) {
      case LlmCancelException():
        AdaptiveSnackBar.show(context, 'LLM operation canceled by user');
      case LlmFailureException():
      case LlmException():
        // stop from the progress from indicating in case there was a failure
        // before any text response happened; the progress indicator uses a null
        // text message to keep progressing. plus we don't want to just show an
        // empty LLM message.
        final llmMessage = widget.viewModel.controller.history.last;
        if (llmMessage.text == null) llmMessage.append('ERROR');

        await AdaptiveAlertDialog.show(
          context: context,
          content: Text(error.toString()),
          actions: [
            AdaptiveDialogAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
    }
  }

  void _onSelectSuggestion(String suggestion) =>
      setState(() => _initialMessage = ChatMessage.user(suggestion, []));
}
