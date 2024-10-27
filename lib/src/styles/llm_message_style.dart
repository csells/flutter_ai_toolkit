import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../fat_icons.dart';
import 'fat_color.dart';
import 'fat_text_style.dart';

/// Style for LLM messages.
class LlmMessageStyle {
  /// Creates an LlmMessageStyle.
  const LlmMessageStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.decoration,
    this.markdownStyle,
  });

  /// The icon to display for the LLM messages.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The decoration for LLM message bubbles.
  final Decoration? decoration;

  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyle;

  /// Provides default style for LLM messages.
  static LlmMessageStyle get defaultStyle => LlmMessageStyle(
        icon: FatIcons.spark_icon,
        iconColor: FatColor.darkIcon,
        iconDecoration: BoxDecoration(
          color: FatColor.llmIconBackground,
          shape: BoxShape.circle,
        ),
        markdownStyle: MarkdownStyleSheet(
          a: FatTextStyle.body1,
          blockquote: FatTextStyle.body1,
          checkbox: FatTextStyle.body1,
          code: FatTextStyle.code,
          del: FatTextStyle.body1,
          em: FatTextStyle.body1,
          h1: FatTextStyle.heading1,
          h2: FatTextStyle.heading2,
          h3: FatTextStyle.body1,
          h4: FatTextStyle.body1,
          h5: FatTextStyle.body1,
          h6: FatTextStyle.body1,
          listBullet: FatTextStyle.body1,
          img: FatTextStyle.body1,
          strong: FatTextStyle.body1,
          p: FatTextStyle.body1,
          tableBody: FatTextStyle.body1,
          tableHead: FatTextStyle.body1,
        ),
        decoration: BoxDecoration(
          color: FatColor.llmMessageBackground,
          border: Border.all(
            color: FatColor.llmMessageOutline,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      );

  /// Resolves the provided style with the default style.
  ///
  /// This method creates a new [LlmMessageStyle] by combining the provided [style]
  /// with the [defaultStyle]. If a property is not specified in the provided [style],
  /// it falls back to the corresponding property in the [defaultStyle].
  ///
  /// If [defaultStyle] is not provided, it uses [LlmMessageStyle.defaultStyle].
  ///
  /// Parameters:
  ///   - [style]: The custom style to apply. Can be null.
  ///   - [defaultStyle]: The default style to use as a fallback. If null, uses [LlmMessageStyle.defaultStyle].
  ///
  /// Returns:
  ///   A new [LlmMessageStyle] instance with resolved properties.
  static LlmMessageStyle resolve(
    LlmMessageStyle? style, {
    LlmMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= LlmMessageStyle.defaultStyle;
    return LlmMessageStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
      markdownStyle: style?.markdownStyle ?? defaultStyle.markdownStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }
}
