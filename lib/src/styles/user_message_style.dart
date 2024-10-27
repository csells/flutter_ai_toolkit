import 'package:flutter/widgets.dart';

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
        // TODO
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

  /// Resolves the UserMessageStyle by combining the provided style with default values.
  ///
  /// This method takes an optional [userMessageStyle] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses [UserMessageStyle.defaultStyle].
  ///
  /// [userMessageStyle] - The custom UserMessageStyle to apply. Can be null.
  /// [defaultStyle] - The default UserMessageStyle to use as a base. If null, uses [UserMessageStyle.defaultStyle].
  ///
  /// Returns a new [UserMessageStyle] instance with resolved properties.
  static UserMessageStyle resolve(
    UserMessageStyle? userMessageStyle, {
    UserMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= UserMessageStyle.defaultStyle;
    return UserMessageStyle(
      textStyle: userMessageStyle?.textStyle ?? defaultStyle.textStyle,
      backgroundColor:
          userMessageStyle?.backgroundColor ?? defaultStyle.backgroundColor,
      outlineColor: userMessageStyle?.outlineColor ?? defaultStyle.outlineColor,
      shape: userMessageStyle?.shape ?? defaultStyle.shape,
    );
  }
}
