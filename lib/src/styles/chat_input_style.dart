// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'style_helpers.dart' as sh;
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

/// Style for the input text box.
@immutable
class ChatInputStyle {
  /// Creates an InputBoxStyle.
  const ChatInputStyle({
    this.textStyle,
    this.hintStyle,
    this.hintText,
    this.backgroundColor,
    this.decoration,
  });

  /// Merges the provided styles with the default styles.
  factory ChatInputStyle.resolve(
    ChatInputStyle? style, {
    ChatInputStyle? defaultStyle,
  }) {
    defaultStyle ??= ChatInputStyle.defaultStyle();
    return ChatInputStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      hintStyle: style?.hintStyle ?? defaultStyle.hintStyle,
      hintText: style?.hintText ?? defaultStyle.hintText,
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }

  /// Provides a default dark style.
  factory ChatInputStyle.darkStyle() {
    final style = ChatInputStyle.lightStyle();
    return ChatInputStyle(
      decoration: sh.invertDecoration(style.decoration),
      textStyle: sh.invertTextStyle(style.textStyle),
      // inversion doesn't look great here
      // hintStyle: sh.invertTextStyle(style.hintStyle),
      hintStyle: ToolkitTextStyles.body2.copyWith(
        color: ToolkitColors.greyBackground,
      ),
      hintText: style.hintText,
      backgroundColor: sh.invertColor(style.backgroundColor),
    );
  }

  /// Provides a default style.
  factory ChatInputStyle.defaultStyle() => ChatInputStyle.lightStyle();

  /// Provides a default light style.
  factory ChatInputStyle.lightStyle() => ChatInputStyle(
        textStyle: ToolkitTextStyles.body2,
        hintStyle:
            ToolkitTextStyles.body2.copyWith(color: ToolkitColors.hintText),
        hintText: 'Ask me anything...',
        backgroundColor: ToolkitColors.containerBackground,
        decoration: BoxDecoration(
          color: ToolkitColors.containerBackground,
          border: Border.all(width: 1, color: ToolkitColors.outline),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The hint text style for the input text box.
  final TextStyle? hintStyle;

  /// The hint text for the input text box.
  final String? hintText;

  /// The background color of the input box.
  final Color? backgroundColor;

  /// The decoration of the input box.
  final Decoration? decoration;
}
