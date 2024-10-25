import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../fat_icons.dart';
import 'fat_colors_styles.dart';

// TODO: merge this with view_styles.dart
// TODO: add icons
// static const IconData submit_icon =
// static const IconData spark_icon =
// static const IconData add =
// static const IconData attach_file =
// static const IconData stop =
// static const IconData mic =
// static const IconData close =
// static const IconData camera_alt =
// static const IconData image =
// static const IconData edit =
// static const IconData content_copy =

/// Style for the entire chat widget.
class LlmChatViewStyle {
  /// Background color of the entire chat widget.
  final Color? backgroundColor;

  /// Style for user messages.
  final UserMessageStyle? userMessageStyle;

  /// Style for LLM messages.
  final LlmMessageStyle? llmMessageStyle;

  /// Style for the input text box.
  final InputBoxStyle? inputBoxStyle;

  /// Style for icon buttons in the chat widget.
  final IconButtonStyle? iconButtonStyle;

  /// Creates a style object for the chat widget.
  const LlmChatViewStyle({
    this.backgroundColor,
    this.userMessageStyle,
    this.llmMessageStyle,
    this.inputBoxStyle,
    this.iconButtonStyle,
  });

  /// Provides default style if none is specified.
  static LlmChatViewStyle get defaultStyles => LlmChatViewStyle(
        backgroundColor: FatColors.containerBackground,
        userMessageStyle: UserMessageStyle.defaultStyle,
        llmMessageStyle: LlmMessageStyle.defaultStyle,
        inputBoxStyle: InputBoxStyle.defaultStyle,
      );
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
  static UserMessageStyle get defaultStyle => UserMessageStyle(
        // textStyle: theme.textTheme.bodyLarge?.copyWith(
        //   color: FatColors.black,
        //   fontWeight: FontWeight.normal,
        // ),
        // backgroundColor: Colors.blue[100],
        // outlineColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      );
}

/// Style for LLM messages.
class LlmMessageStyle {
  /// Creates an LlmMessageStyle.
  const LlmMessageStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.decoration,
    this.markdownStyle,
    this.progressIndicatorColor,
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

  /// The color of the progress indicator.
  final Color? progressIndicatorColor;

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
        progressIndicatorColor: FatColors.black,
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
      progressIndicatorColor:
          style?.progressIndicatorColor ?? defaultStyle.progressIndicatorColor,
    );
  }
}

/// Style for the input text box.
class InputBoxStyle {
  /// Creates an InputBoxStyle.
  const InputBoxStyle({
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
  static InputBoxStyle get defaultStyle => InputBoxStyle(
        textStyle: FatTextStyles.body2,
        hintStyle: FatTextStyles.body2.copyWith(color: FatColors.hintText),
        hintText: "Ask me anything...",
        backgroundColor: FatColors.containerBackground,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: FatColors.outline),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  /// Merges the provided styles with the default styles.
  static InputBoxStyle resolve(
    InputBoxStyle? style, {
    InputBoxStyle? defaultStyle,
  }) {
    defaultStyle ??= InputBoxStyle.defaultStyle;
    return InputBoxStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      hintStyle: style?.hintStyle ?? defaultStyle.hintStyle,
      hintText: style?.hintText ?? defaultStyle.hintText,
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      decoration: style?.decoration ?? defaultStyle.decoration,
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
  factory IconButtonStyle.defaultStyle() {
    return IconButtonStyle(
      // iconColor: Colors.grey[700],
      // backgroundColor: Colors.transparent,
      // outlineColor: Colors.transparent,
      shape: null,
      size: 24.0,
    );
  }
}
