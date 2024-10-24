// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ai_toolkit/src/views/fat_colors_styles.dart';

import '../adaptive_snack_bar.dart';
import '../llm_exception.dart';
import '../models/chat_message.dart';
import '../platform_helper/platform_helper.dart';
import '../providers/forwarding_provider.dart';
import '../providers/llm_provider_interface.dart';
import 'chat_input.dart';
import 'chat_transcript_view.dart';
import 'response_builder.dart';

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
    this.responseBuilder,
    LlmStreamGenerator? messageSender,
    this.welcomeMessage,
    super.key,
  }) : provider = messageSender == null
            ? provider
            : ForwardingProvider(
                provider: provider,
                messageSender: messageSender,
              );

  /// The LLM provider used to generate responses in the chat.
  final LlmProvider provider;

  /// An optional builder function that allows replacing the widget that
  /// displays the response.
  final ResponseBuilder? responseBuilder;

  /// An optional welcome message to display when the chat view is first shown.
  /// If null, no welcome message is displayed.
  final String? welcomeMessage;

  @override
  State<LlmChatView> createState() => _LlmChatViewState();
}

class _LlmResponse {
  final ChatMessage message;
  final void Function(LlmException? error)? onDone;
  StreamSubscription<String>? _subscription;

  _LlmResponse({
    required Stream<String> stream,
    required this.message,
    this.onDone,
  }) {
    _subscription = stream.listen(
      (text) => message.append(text),
      onDone: () => onDone?.call(null),
      cancelOnError: true,
      onError: _error,
    );
  }

  void cancel() => _close(const LlmCancelException());
  void _error(dynamic err) => _close(_exception(err));

  LlmException _exception(dynamic err) => switch (err) {
        (LlmCancelException _) => const LlmCancelException(),
        (LlmFailureException ex) => ex,
        _ => LlmFailureException(err.toString()),
      };

  void _close(LlmException error) {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;
    onDone?.call(error);
  }
}

class _LlmChatViewState extends State<LlmChatView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _transcript = List<ChatMessage>.empty(growable: true);

  _LlmResponse? _pendingPromptResponse;
  ChatMessage? _initialMessage;
  _LlmResponse? _pendingSttResponse;

  @override
  void initState() {
    super.initState();
    if (widget.welcomeMessage != null) {
      _transcript.add(ChatMessage.llmWelcome(widget.welcomeMessage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: FatColors.containerBackground,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: ChatTranscriptView(
              transcript: _transcript,
              onEditMessage:
                  _pendingPromptResponse == null ? _onEditMessage : null,
              responseBuilder: widget.responseBuilder,
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
    );
  }

  Future<void> _onSendMessage(
    String prompt,
    Iterable<Attachment> attachments,
  ) async {
    _initialMessage = null;

    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();

    _transcript.addAll([userMessage, llmMessage]);

    _pendingPromptResponse = _LlmResponse(
      stream: widget.provider.sendMessageStream(
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

  void _onEditMessage(ChatMessage message) {
    assert(_pendingPromptResponse == null);

    // remove the last llm message
    assert(_transcript.last.origin.isLlm);
    _transcript.removeLast();

    // remove the last user message
    assert(_transcript.last.origin.isUser);
    final userMessage = _transcript.removeLast();

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

    _pendingSttResponse = _LlmResponse(
      stream: widget.provider.generateStream(
        prompt,
        attachments: attachments,
      ),
      message: ChatMessage.llm(),
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

    final message = switch (error) {
      LlmCancelException() => 'LLM operation canceled by user',
      LlmFailureException() ||
      LlmException() =>
        'LLM operation failed: ${error.message}',
    };

    AdaptiveSnackBar.show(context, message);
  }
}
