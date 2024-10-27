// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../flutter_ai_toolkit.dart';
import '../../views/response_builder.dart';

/// A view model class for managing the state and data of a chat interface.
///
/// This class encapsulates the necessary components for rendering and
/// interacting with a chat view, including the LLM provider, message transcript,
/// response builder, welcome message, and styling options.
class ChatViewModel {
  /// Creates a new [ChatViewModel] instance.
  ///
  /// All parameters are required to ensure a fully functional chat view.
  ///
  /// - [provider]: The LLM provider used to generate responses in the chat.
  /// - [transcript]: The list of chat messages to display.
  /// - [responseBuilder]: An optional builder function for customizing response display.
  /// - [welcomeMessage]: An optional welcome message to show when the chat view is first displayed.
  /// - [style]: The styling options for the chat view.
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
