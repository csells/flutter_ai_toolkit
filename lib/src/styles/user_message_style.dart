// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'fat_colors.dart';
import 'fat_text_styles.dart';
import 'style_helpers.dart' as sh;

/// Style for user messages.
class UserMessageStyle {
  /// Creates a UserMessageStyle.
  const UserMessageStyle({
    this.textStyle,
    this.decoration,
  });

  /// Resolves the UserMessageStyle by combining the provided style with default
  /// values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses
  /// [UserMessageStyle.defaultStyle].
  ///
  /// [style] - The custom UserMessageStyle to apply. Can be null.
  /// [defaultStyle] - The default UserMessageStyle to use as a base. If null,
  /// uses [UserMessageStyle.defaultStyle].
  ///
  /// Returns a new [UserMessageStyle] instance with resolved properties.
  factory UserMessageStyle.resolve(
    UserMessageStyle? style, {
    UserMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= UserMessageStyle.defaultStyle();
    return UserMessageStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }

  /// Provides a default dark style.
  factory UserMessageStyle.darkStyle() {
    final style = UserMessageStyle.lightStyle();
    return UserMessageStyle(
      textStyle: sh.invertTextStyle(style.textStyle),
      // inversion doesn't look great here
      // decoration: sh.invertDecoration(style.decoration),
      decoration: (style.decoration! as BoxDecoration).copyWith(
        color: FatColors.greyBackground,
      ),
    );
  }

  /// Provides default style data for user messages.
  factory UserMessageStyle.defaultStyle() => UserMessageStyle.lightStyle();

  /// Provides a default light style.
  factory UserMessageStyle.lightStyle() => UserMessageStyle(
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

  /// The text style for user messages.
  final TextStyle? textStyle;

  /// The decoration for user message bubbles.
  final Decoration? decoration;
}
