// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'fat_colors_styles.dart';

/// A circular button widget with an icon.
///
/// This widget creates a circular button with a customizable icon, size, and
/// color. It can be enabled or disabled based on the presence of an [onPressed]
/// callback.
class CircleButton extends StatelessWidget {
  /// Creates a [CircleButton].
  ///
  /// The [icon] parameter is required and specifies the icon to be displayed.
  /// The [onPressed] callback is optional and determines if the button is
  /// enabled. The [color] parameter sets the background color of the button
  /// when enabled. The [size] parameter determines the diameter of the circular
  /// button.
  const CircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color = FatColors.darkIcon,
    this.size = 40,
  });

  /// The icon to display in the button.
  final IconData icon;

  /// The callback that is called when the button is tapped.
  /// If null, the button will be disabled.
  final VoidCallback? onPressed;

  /// The background color of the button when enabled.
  final Color color;

  /// The diameter of the circular button.
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _enabled ? color : FatColors.disabledButton,
          ),
          child: Icon(
            icon,
            color: _enabled ? FatColors.darkButtonIcon : FatColors.darkIcon,
            size: size * 0.6,
          ),
        ),
      );

  /// Whether the button is enabled.
  bool get _enabled => onPressed != null;
}

/// A widget that displays a horizontal bar of [CircleButton]s.
///
/// This widget creates a container with rounded corners that houses a series of
/// [CircleButton]s. The buttons are laid out horizontally and can overflow if
/// there's not enough space.
class CircleButtonBar extends StatelessWidget {
  /// Creates a [CircleButtonBar].
  ///
  /// The [buttons] parameter is required and specifies the list of
  /// [CircleButton]s to be displayed in the bar.
  const CircleButtonBar(this.buttons, {super.key});

  /// The list of [CircleButton]s to be displayed in the bar.
  final List<CircleButton> buttons;

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
