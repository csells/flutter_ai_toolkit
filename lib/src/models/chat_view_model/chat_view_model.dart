// ignore_for_file: public_member_api_docs

import '../../../flutter_ai_toolkit.dart';
import '../../views/response_builder.dart';

class ChatViewModel {
  ChatViewModel({
    required this.provider,
    required this.transcript,
    required this.responseBuilder,
    required this.welcomeMessage,
    required this.style,
  });

  /// The LLM provider used to generate responses in the chat.
  final LlmProvider provider;

  /// The list of chat messages to display.
  final List<LlmChatMessage> transcript;

  /// An optional builder function that allows replacing the widget that
  /// displays the response.
  final ResponseBuilder? responseBuilder;

  /// An optional welcome message to display when the chat view is first shown.
  /// If null, no welcome message is displayed.
  final String? welcomeMessage;

  /// The style of the chat view.
  final LlmChatViewStyle? style;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatViewModel &&
          other.provider == provider &&
          other.responseBuilder == responseBuilder &&
          other.welcomeMessage == welcomeMessage &&
          other.style == style);

  @override
  int get hashCode => Object.hash(
        provider,
        responseBuilder,
        welcomeMessage,
        style,
      );
}
