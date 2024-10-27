// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../llm_chat_view_controller.dart';
import '../styles/llm_chat_view_style.dart';
import '../views/response_builder.dart';

/// A view model class that manages the state and configuration of a chat interface.
///
/// This class holds the controller and styling information needed to render and
/// manage a chat view. It works in conjunction with [LlmChatViewController] to
/// handle the business logic and state management of the chat interface.
class ChatViewModel {
  /// Creates a [ChatViewModel] with the required controller and style.
  ///
  /// The [controller] parameter must not be null and manages the chat state and
  /// interactions.
  ///
  /// The [style] parameter allows customizing the visual appearance of the chat
  /// interface. If null, default styling will be used.
  ChatViewModel({
    required this.controller,
    required this.style,
    this.responseBuilder,
  });

  /// The controller that manages the chat state and interactions.
  ///
  /// This controller handles operations like sending messages, managing the chat
  /// history, and processing responses from the LLM provider.
  final LlmChatViewController controller;

  /// The style configuration for the chat view.
  ///
  /// Defines visual properties like colors, decorations, and layout parameters
  /// for the chat interface. If null, default styling will be applied.
  final LlmChatViewStyle? style;

  /// The builder for the chat response.
  final ResponseBuilder? responseBuilder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatViewModel &&
          other.controller == controller &&
          other.style == style);

  @override
  int get hashCode => Object.hash(
        controller,
        style,
      );
}
