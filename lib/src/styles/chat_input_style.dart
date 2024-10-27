import 'package:flutter/widgets.dart';

import 'fat_color.dart';
import 'fat_text_style.dart';

/// Style for the input text box.
class ChatInputStyle {
  /// Creates an InputBoxStyle.
  const ChatInputStyle({
    this.textStyle,
    this.hintStyle,
    this.hintText,
    this.backgroundColor,
    this.decoration,
  });

  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The hint text style for the input text box.
  final TextStyle? hintStyle;

  /// The hint text for the input text box.
  final String? hintText;

  /// The background color of the input box.
  final Color? backgroundColor;

  /// The shape of the input box.
  final BoxDecoration? decoration;

  /// Provides default style for the input text box.
  static ChatInputStyle get defaultStyle => ChatInputStyle(
        textStyle: FatTextStyle.body2,
        hintStyle: FatTextStyle.body2.copyWith(color: FatColor.hintText),
        hintText: "Ask me anything...",
        backgroundColor: FatColor.containerBackground,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: FatColor.outline),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  /// Merges the provided styles with the default styles.
  static ChatInputStyle resolve(
    ChatInputStyle? style, {
    ChatInputStyle? defaultStyle,
  }) {
    defaultStyle ??= ChatInputStyle.defaultStyle;
    return ChatInputStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      hintStyle: style?.hintStyle ?? defaultStyle.hintStyle,
      hintText: style?.hintText ?? defaultStyle.hintText,
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }
}
