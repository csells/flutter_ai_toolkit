// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'action_button_type.dart';
import 'fat_colors.dart';
import 'fat_icons.dart';
import 'fat_text_styles.dart';
import 'style_helpers.dart' as sh;

/// Style for icon buttons.
class ActionButtonStyle {
  /// The icon to display for the icon button.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The tooltip for the icon button.
  final String? tooltip;

  /// The text style of the tooltip.
  final TextStyle? tooltipTextStyle;

  /// The decoration of the tooltip.
  final Decoration? tooltipDecoration;

  /// Creates an IconButtonStyle.
  const ActionButtonStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.tooltip,
    this.tooltipTextStyle,
    this.tooltipDecoration,
  });

  /// Provides default style for icon buttons.
  static ActionButtonStyle defaultStyle(ActionButtonType type) =>
      lightStyle(type);

  /// Provides default light style for icon buttons.
  static ActionButtonStyle lightStyle(ActionButtonType type) {
    IconData icon;
    var color = FatColors.darkIcon;
    var bgColor = FatColors.lightButtonBackground;
    String tooltip;
    var tooltipTextStyle = FatTextStyles.tooltip;
    var tooltipDecoration = BoxDecoration(
      color: FatColors.tooltipBackground,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
    );

    switch (type) {
      case ActionButtonType.add:
        icon = FatIcons.add;
        tooltip = 'Add Attachment';
        break;
      case ActionButtonType.attachFile:
        icon = FatIcons.attach_file;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Attach File';
        break;
      case ActionButtonType.camera:
        icon = FatIcons.camera_alt;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Take Photo';
        break;
      case ActionButtonType.stop:
        icon = FatIcons.stop;
        tooltip = 'Stop';
        break;
      case ActionButtonType.close:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Close';
        break;
      case ActionButtonType.copy:
        icon = FatIcons.content_copy;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Copy to Clipboard';
        break;
      case ActionButtonType.edit:
        icon = FatIcons.edit;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Edit Message';
        break;
      case ActionButtonType.gallery:
        icon = FatIcons.image;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Image Gallery';
        break;
      case ActionButtonType.record:
        icon = FatIcons.mic;
        tooltip = 'Record Audio';
        break;
      case ActionButtonType.submit:
        icon = FatIcons.submit_icon;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Submit Message';
        break;
      case ActionButtonType.closeMenu:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.greyBackground;
        tooltip = 'Close Menu';
        break;
    }

    return ActionButtonStyle(
      icon: icon,
      iconColor: color,
      iconDecoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      tooltip: tooltip,
      tooltipTextStyle: tooltipTextStyle,
      tooltipDecoration: tooltipDecoration,
    );
  }

  /// Provides a default dark style.
  static ActionButtonStyle darkStyle(ActionButtonType type) {
    final style = lightStyle(type);
    return ActionButtonStyle(
      icon: style.icon,
      iconColor: sh.invertColor(style.iconColor),
      iconDecoration: switch (type) {
        ActionButtonType.add ||
        ActionButtonType.record ||
        ActionButtonType.stop =>
          BoxDecoration(
            color: FatColors.greyBackground,
            shape: BoxShape.circle,
          ),
        _ => sh.invertDecoration(style.iconDecoration),
      },
      tooltip: style.tooltip,
      tooltipTextStyle: sh.invertTextStyle(style.tooltipTextStyle),
      tooltipDecoration: sh.invertDecoration(style.tooltipDecoration),
    );
  }

  /// Resolves the IconButtonStyle by combining the provided style with default
  /// values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses
  /// [IconButtonStyle.defaultStyle()].
  ///
  /// [style] - The custom IconButtonStyle to apply. Can be null. [defaultStyle]
  /// - The default IconButtonStyle to use as a base. If null, uses
  /// [IconButtonStyle.defaultStyle()].
  ///
  /// Returns a new [ActionButtonStyle] instance with resolved properties.
  static ActionButtonStyle resolve(
    ActionButtonStyle? style, {
    required ActionButtonStyle defaultStyle,
  }) =>
      ActionButtonStyle(
        icon: style?.icon ?? defaultStyle.icon,
        iconColor: style?.iconColor ?? defaultStyle.iconColor,
        iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
        tooltip: style?.tooltip ?? defaultStyle.tooltip,
        tooltipTextStyle:
            style?.tooltipTextStyle ?? defaultStyle.tooltipTextStyle,
        tooltipDecoration:
            style?.tooltipDecoration ?? defaultStyle.tooltipDecoration,
      );
}
