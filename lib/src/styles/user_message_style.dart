import 'package:flutter/widgets.dart';

import 'fat_colors.dart';
import 'fat_text_styles.dart';

/// Style for user messages.
class UserMessageStyle {
  /// The text style for user messages.
  final TextStyle? textStyle;

  /// The decoration for user message bubbles.
  final Decoration? decoration;

  /// Creates a UserMessageStyle.
  const UserMessageStyle({
    this.textStyle,
    this.decoration,
  });

  /// Provides default style data for user messages.
  static UserMessageStyle get defaultStyle => UserMessageStyle(
        textStyle: FatTextStyles.body1,
        decoration: const BoxDecoration(
          color: FatColors.userMessageBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.zero,
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      );

  /// Resolves the UserMessageStyle by combining the provided style with default values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses [UserMessageStyle.defaultStyle].
  ///
  /// [style] - The custom UserMessageStyle to apply. Can be null.
  /// [defaultStyle] - The default UserMessageStyle to use as a base. If null, uses [UserMessageStyle.defaultStyle].
  ///
  /// Returns a new [UserMessageStyle] instance with resolved properties.
  static UserMessageStyle resolve(
    UserMessageStyle? style, {
    UserMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= UserMessageStyle.defaultStyle;
    return UserMessageStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }
}
