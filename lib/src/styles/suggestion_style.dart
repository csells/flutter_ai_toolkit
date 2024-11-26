// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'style_helpers.dart' as sh;
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

@immutable

/// A class that defines the style for suggestions.
class SuggestionStyle {
  /// Creates a [SuggestionStyle].
  ///
  /// The [textStyle] and [decoration] parameters can be used to customize
  /// the appearance of the suggestion.
  const SuggestionStyle({
    this.textStyle,
    this.decoration,
  });

  /// Resolves the [SuggestionStyle] by merging the provided [style] with the
  /// [defaultStyle].
  ///
  /// If [style] is null, the [defaultStyle] is used. If [defaultStyle] is not
  /// provided, the [defaultStyle] is obtained from
  /// [SuggestionStyle.defaultStyle].
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
  ///
  /// This style is typically used as the base style for suggestions.
  factory SuggestionStyle.defaultStyle() => SuggestionStyle.lightStyle();

  /// Provides a default dark style.
  ///
  /// This style is typically used for suggestions in dark mode.
  factory SuggestionStyle.darkStyle() {
    final style = SuggestionStyle.lightStyle();
    return SuggestionStyle(
      textStyle: sh.invertTextStyle(style.textStyle),
      decoration: const BoxDecoration(
        color: ToolkitColors.greyBackground,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );
  }

  /// Provides a default light style.
  ///
  /// This style is typically used for suggestions in light mode.
  factory SuggestionStyle.lightStyle() => SuggestionStyle(
        textStyle: ToolkitTextStyles.body1,
        decoration: const BoxDecoration(
          color: ToolkitColors.userMessageBackground,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      );

  /// The text style for the suggestion.
  final TextStyle? textStyle;

  /// The decoration for the suggestion.
  final Decoration? decoration;
}
