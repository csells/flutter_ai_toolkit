// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../../flutter_ai_toolkit.dart';
import '../views/response_builder.dart';

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

class ChatViewModelProvider extends InheritedWidget {
  const ChatViewModelProvider({
    super.key,
    required super.child,
    required this.viewModel,
  });

  final ChatViewModel viewModel;

  static ChatViewModel of(BuildContext context) {
    final viewModel = maybeOf(context);
    assert(viewModel != null, 'No ChatViewModelProvider found in context');
    return viewModel!;
  }

  static ChatViewModel? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ChatViewModelProvider>()
      ?.viewModel;

  @override
  bool updateShouldNotify(ChatViewModelProvider oldWidget) {
    final shouldNotify = viewModel != oldWidget.viewModel;
    if (shouldNotify) {
      debugPrint('ChatViewModelProvider: updateShouldNotify => true');
    } else {
      debugPrint('ChatViewModelProvider: updateShouldNotify => false');
    }
    return shouldNotify;
  }
}

class ChatViewModelClient extends StatelessWidget {
  const ChatViewModelClient({
    required this.builder,
    this.child,
    super.key,
  });

  final Widget Function(
      BuildContext context, ChatViewModel viewModel, Widget? child) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) =>
      builder(context, ChatViewModelProvider.of(context), child);
}
