// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'fat_colors_styles.dart';
import 'llm_chat_view_style.dart';

/// A button widget with an icon.
///
/// This widget creates a button with a customizable icon, size, decoration, and
/// color. It can be enabled or disabled based on the presence of an [onPressed]
/// callback.
class ActionButton extends StatelessWidget {
  /// Creates an [ActionButton].
  ///
  /// The [onPressed] callback is required and is called when the button is tapped.
  /// The [icon] parameter specifies the icon to display in the button.
  /// The [iconColor] determines the color of the icon.
  /// The [iconDecoration] defines the decoration of the button.
  /// The [size] parameter sets the diameter of the circular button, defaulting to 40.
  const ActionButton({
    super.key,
    required this.onPressed,
    required this.style,
    this.size = 40,
  });

  /// The callback that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback onPressed;

  /// The style of the button.
  final ActionButtonStyle style;

  /// The diameter of the circular button.
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: style.iconDecoration,
          child: Icon(
            style.icon,
            color: style.iconColor,
            size: size * 0.6,
          ),
        ),
      );
}

/// A widget that displays a horizontal bar of [ActionButton]s.
///
/// This widget creates a container with rounded corners that houses a series of
/// [ActionButton]s. The buttons are laid out horizontally and can overflow if
/// there's not enough space.
class ActionButtonBar extends StatelessWidget {
  /// Creates a [ActionButtonBar].
  ///
  /// The [buttons] parameter is required and specifies the list of
  /// [ActionButton]s to be displayed in the bar.
  const ActionButtonBar(this.buttons, {super.key});

  /// The list of [ActionButton]s to be displayed in the bar.
  final List<ActionButton> buttons;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: FatColors.darkButtonBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: OverflowBar(
          children: buttons,
        ),
      );
}
