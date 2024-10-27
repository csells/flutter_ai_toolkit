// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../flutter_ai_toolkit.dart';
import '../views/response_builder.dart';

/// A view model class for managing the state and data of a chat interface.
///
/// This class encapsulates the necessary components for rendering and
/// interacting with a chat view, including the LLM provider, message history,
/// response builder, welcome message, and styling options.
class ChatViewModel {
  /// Creates a new [ChatViewModel] instance.
  ///
  /// All parameters are required to ensure a fully functional chat view.
  ///
  /// - [provider]: The LLM provider used to generate responses in the chat.
  /// - [responseBuilder]: An optional builder function for customizing response display.
  /// - [welcomeMessage]: An optional welcome message to show when the chat view is first displayed.
  /// - [style]: The styling options for the chat view.
  ChatViewModel({
    required this.provider,
    required this.responseBuilder,
    required this.style,
  });

  /// The LLM provider used to generate responses in the chat.
  final LlmProvider provider;

  /// An optional builder function that allows replacing the widget that
  /// displays the response.
  final ResponseBuilder? responseBuilder;

  /// The style of the chat view.
  final LlmChatViewStyle? style;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatViewModel &&
          other.provider == provider &&
          other.responseBuilder == responseBuilder &&
          other.style == style);

  @override
  int get hashCode => Object.hash(
        provider,
        responseBuilder,
        style,
      );
}
