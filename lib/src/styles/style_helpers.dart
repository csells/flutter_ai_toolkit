// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// Inverts the color.
Color invertColor(Color? color) => Color.fromARGB(
      color!.alpha,
      255 - color.red,
      255 - color.green,
      255 - color.blue,
    );

/// Inverts the color of a [Decoration] if it's a [BoxDecoration] or [ShapeDecoration].
///
/// This function takes a [Decoration] and attempts to invert its color:
/// - For [BoxDecoration], it creates a new instance with the inverted color.
/// - For [ShapeDecoration], it creates a new instance with the inverted color while preserving other properties.
/// - For other types of decorations, it returns the original decoration unchanged.
///
/// Parameters:
///   * [decoration]: The [Decoration] to invert. Can be null.
///
/// Returns:
///   A new [Decoration] with inverted color if applicable, or the original decoration.
///   Returns null if the input is null.
Decoration invertDecoration(Decoration? decoration) => switch (decoration!) {
      BoxDecoration d => d.copyWith(color: invertColor(d.color)),
      ShapeDecoration d => ShapeDecoration(
          color: invertColor(d.color),
          shape: d.shape,
          shadows: d.shadows,
          image: d.image,
          gradient: d.gradient,
        ),
      _ => decoration,
    };

/// Inverts the color of a [TextStyle].
///
/// This function takes a [TextStyle] and creates a new instance with the inverted color.
/// If the input style is null, it returns null.
///
/// Parameters:
///   * [style]: The [TextStyle] to invert. Can be null.
///
/// Returns:
///   A new [TextStyle] with inverted color if the input is not null, otherwise null.
TextStyle invertTextStyle(TextStyle? style) =>
    style!.copyWith(color: invertColor(style.color));
