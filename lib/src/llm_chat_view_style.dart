import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Style for the entire chat widget.
class LlmChatViewStyle {
  /// Background color of the entire chat widget.
  final Color? backgroundColor;

  /// Style for user messages.
  final UserMessageStyle? userMessageStyle;

  /// Style for LLM messages.
  final LlmMessageStyle? llmMessageStyle;

  /// Style for the input text box.
  final InputTextBoxStyle? inputTextBoxStyle;

  /// Style for icon buttons in the chat widget.
  final IconButtonStyle? iconButtonStyle;

  /// Icon for the plus button (e.g., attachment button).
  final IconData? plusButtonIcon;

  /// Icon for the send button.
  final IconData? sendButtonIcon;

  /// Creates a style object for the chat widget.
  const LlmChatViewStyle({
    this.backgroundColor,
    this.userMessageStyle,
    this.llmMessageStyle,
    this.inputTextBoxStyle,
    this.iconButtonStyle,
    this.plusButtonIcon,
    this.sendButtonIcon,
  });

  /// Provides default style if none is specified.
  factory LlmChatViewStyle.defaultStyle(BuildContext context) {
    // TODO: merge this with view_styles.dart
    final ThemeData theme = Theme.of(context);
    return LlmChatViewStyle(
      backgroundColor: theme.scaffoldBackgroundColor,
      userMessageStyle: UserMessageStyle.defaultStyle(context),
      llmMessageStyle: LlmMessageStyle.defaultStyle(context),
      inputTextBoxStyle: InputTextBoxStyle.defaultStyle(context),
      iconButtonStyle: IconButtonStyle.defaultStyle(context),
      plusButtonIcon: Icons.add, // Default icon for plus button
      sendButtonIcon: Icons.send, // Default icon for send button
    );
  }
}

/// Style for user messages.
class UserMessageStyle {
  /// The text style for user messages.
  final TextStyle? textStyle;

  /// The background color for user message bubbles.
  final Color? backgroundColor;

  /// The outline color for user message bubbles.
  final Color? outlineColor;

  /// The shape of user message bubbles.
  final ShapeBorder? shape;

  /// Creates a UserMessageStyle.
  const UserMessageStyle({
    this.textStyle,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default style data for user messages.
  factory UserMessageStyle.defaultStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return UserMessageStyle(
      textStyle: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      backgroundColor: Colors.blue[100],
      outlineColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

/// Style for LLM messages.
class LlmMessageStyle {
  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyleSheet;

  /// The background color for LLM message bubbles.
  final Color? backgroundColor;

  /// The outline color for LLM message bubbles.
  final Color? outlineColor;

  /// The shape of LLM message bubbles.
  final ShapeBorder? shape;

  /// Creates an LlmMessageStyle.
  const LlmMessageStyle({
    this.markdownStyleSheet,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default style for LLM messages.
  factory LlmMessageStyle.defaultStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LlmMessageStyle(
      markdownStyleSheet: MarkdownStyleSheet.fromTheme(theme),
      backgroundColor: Colors.grey[200],
      outlineColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

/// Style for the input text box.
class InputTextBoxStyle {
  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The background color of the input text box.
  final Color? backgroundColor;

  /// The outline color of the input text box.
  final Color? outlineColor;

  /// The shape of the input text box.
  final ShapeBorder? shape;

  /// Creates an InputTextBoxStyle.
  const InputTextBoxStyle({
    this.textStyle,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default style for the input text box.
  factory InputTextBoxStyle.defaultStyle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InputTextBoxStyle(
      textStyle: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      outlineColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
    );
  }
}

/// Style for icon buttons.
class IconButtonStyle {
  /// The color of the icon.
  final Color? iconColor;

  /// The background color of the icon button.
  final Color? backgroundColor;

  /// The outline color of the icon button.
  final Color? outlineColor;

  /// The shape of the icon button.
  final ShapeBorder? shape;

  /// The size of the icon button.
  final double? size;

  /// Creates an IconButtonStyle.
  const IconButtonStyle({
    this.iconColor,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
    this.size,
  });

  /// Provides default style for icon buttons.
  factory IconButtonStyle.defaultStyle(BuildContext context) {
    return IconButtonStyle(
      iconColor: Colors.grey[700],
      backgroundColor: Colors.transparent,
      outlineColor: Colors.transparent,
      shape: null,
      size: 24.0,
    );
  }
}
