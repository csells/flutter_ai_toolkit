import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// Theme data for the entire chat widget.
class LlmChatViewThemeData {
  /// Background color of the entire chat widget.
  final Color? backgroundColor;

  /// Theme data for user messages.
  final UserMessageThemeData? userMessageTheme;

  /// Theme data for LLM messages.
  final LlmMessageThemeData? llmMessageTheme;

  /// Theme data for the input text box.
  final InputTextBoxThemeData? inputTextBoxTheme;

  /// Theme data for icon buttons in the chat widget.
  final IconButtonThemeData? iconButtonTheme;

  /// Icon for the plus button (e.g., attachment button).
  final IconData? plusButtonIcon;

  /// Icon for the send button.
  final IconData? sendButtonIcon;

  /// Creates a theme data object for the chat widget.
  const LlmChatViewThemeData({
    this.backgroundColor,
    this.userMessageTheme,
    this.llmMessageTheme,
    this.inputTextBoxTheme,
    this.iconButtonTheme,
    this.plusButtonIcon,
    this.sendButtonIcon,
  });

  /// Provides default theme data if none is specified.
  factory LlmChatViewThemeData.defaultTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LlmChatViewThemeData(
      backgroundColor: theme.scaffoldBackgroundColor,
      userMessageTheme: UserMessageThemeData.defaultTheme(context),
      llmMessageTheme: LlmMessageThemeData.defaultTheme(context),
      inputTextBoxTheme: InputTextBoxThemeData.defaultTheme(context),
      iconButtonTheme: IconButtonThemeData.defaultTheme(context),
      plusButtonIcon: Icons.add, // Default icon for plus button
      sendButtonIcon: Icons.send, // Default icon for send button
    );
  }
}

/// An inherited widget that provides the `ChatWidgetThemeData` to its descendants.
class ChatWidgetTheme extends InheritedWidget {
  /// The theme data to be provided to descendants.
  final LlmChatViewThemeData data;

  /// Creates a ChatWidgetTheme.
  ///
  /// The [data] and [child] arguments must not be null.
  const ChatWidgetTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Retrieves the closest instance of `ChatWidgetThemeData`.
  static LlmChatViewThemeData of(BuildContext context) {
    final ChatWidgetTheme? theme =
        context.dependOnInheritedWidgetOfExactType<ChatWidgetTheme>();
    return theme?.data ?? LlmChatViewThemeData.defaultTheme(context);
  }

  @override
  bool updateShouldNotify(ChatWidgetTheme oldWidget) => data != oldWidget.data;
}

/// Theme data for user messages.
class UserMessageThemeData {
  /// The text style for user messages.
  final TextStyle? textStyle;

  /// The background color for user message bubbles.
  final Color? backgroundColor;

  /// The outline color for user message bubbles.
  final Color? outlineColor;

  /// The shape of user message bubbles.
  final ShapeBorder? shape;

  /// Creates a UserMessageThemeData.
  const UserMessageThemeData({
    this.textStyle,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default theme data for user messages.
  factory UserMessageThemeData.defaultTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return UserMessageThemeData(
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

/// Theme data for LLM messages.
class LlmMessageThemeData {
  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyleSheet;

  /// The background color for LLM message bubbles.
  final Color? backgroundColor;

  /// The outline color for LLM message bubbles.
  final Color? outlineColor;

  /// The shape of LLM message bubbles.
  final ShapeBorder? shape;

  /// Creates an LlmMessageThemeData.
  const LlmMessageThemeData({
    this.markdownStyleSheet,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default theme data for LLM messages.
  factory LlmMessageThemeData.defaultTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LlmMessageThemeData(
      markdownStyleSheet: MarkdownStyleSheet.fromTheme(theme),
      backgroundColor: Colors.grey[200],
      outlineColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}

/// Theme data for the input text box.
class InputTextBoxThemeData {
  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The background color of the input text box.
  final Color? backgroundColor;

  /// The outline color of the input text box.
  final Color? outlineColor;

  /// The shape of the input text box.
  final ShapeBorder? shape;

  /// Creates an InputTextBoxThemeData.
  const InputTextBoxThemeData({
    this.textStyle,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default theme data for the input text box.
  factory InputTextBoxThemeData.defaultTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InputTextBoxThemeData(
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

/// Theme data for icon buttons.
class IconButtonThemeData {
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

  /// Creates an IconButtonThemeData.
  const IconButtonThemeData({
    this.iconColor,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
    this.size,
  });

  /// Provides default theme data for icon buttons.
  factory IconButtonThemeData.defaultTheme(BuildContext context) {
    return IconButtonThemeData(
      iconColor: Colors.grey[700],
      backgroundColor: Colors.transparent,
      outlineColor: Colors.transparent,
      shape: null,
      size: 24.0,
    );
  }
}
