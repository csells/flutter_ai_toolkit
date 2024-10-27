import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'fat_colors.dart';
import 'fat_icons.dart';
import 'fat_text_styles.dart';

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
        iconColor: FatColors.darkIcon,
        iconDecoration: BoxDecoration(
          color: FatColors.llmIconBackground,
          shape: BoxShape.circle,
        ),
        markdownStyle: MarkdownStyleSheet(
          a: FatTextStyles.body1,
          blockquote: FatTextStyles.body1,
          checkbox: FatTextStyles.body1,
          code: FatTextStyles.code,
          del: FatTextStyles.body1,
          em: FatTextStyles.body1,
          h1: FatTextStyles.heading1,
          h2: FatTextStyles.heading2,
          h3: FatTextStyles.body1,
          h4: FatTextStyles.body1,
          h5: FatTextStyles.body1,
          h6: FatTextStyles.body1,
          listBullet: FatTextStyles.body1,
          img: FatTextStyles.body1,
          strong: FatTextStyles.body1,
          p: FatTextStyles.body1,
          tableBody: FatTextStyles.body1,
          tableHead: FatTextStyles.body1,
        ),
        decoration: BoxDecoration(
          color: FatColors.llmMessageBackground,
          border: Border.all(
            color: FatColors.llmMessageOutline,
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
