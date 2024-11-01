// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'fat_colors.dart';
import 'fat_text_styles.dart';
import 'style_helpers.dart' as sh;

@immutable
class SuggestionStyle {
  /// Creates an SuggestionStyle.
  const SuggestionStyle({
    this.textStyle,
    this.decoration,
  });

  factory SuggestionStyle.resolve(
    SuggestionStyle? style, {
    SuggestionStyle? defaultStyle,
  }) {
    defaultStyle ??= SuggestionStyle.defaultStyle();
    return SuggestionStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }

  /// Provides a default style.
  factory SuggestionStyle.defaultStyle() => SuggestionStyle.lightStyle();

  /// Provides a default dark style.
  factory SuggestionStyle.darkStyle() {
    final style = SuggestionStyle.lightStyle();
    return SuggestionStyle(
      textStyle: sh.invertTextStyle(style.textStyle),
      decoration: const BoxDecoration(
        color: FatColors.greyBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  /// Provides a default light style.
  factory SuggestionStyle.lightStyle() => SuggestionStyle(
        textStyle: FatTextStyles.body1,
        decoration: const BoxDecoration(
          color: FatColors.userMessageBackground,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );

  /// The text style for the suggestion.
  final TextStyle? textStyle;

  /// The decoration for the suggestion.
  final Decoration? decoration;
}
