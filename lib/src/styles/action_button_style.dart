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
  /// Creates an IconButtonStyle.
  const ActionButtonStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.tooltip,
    this.tooltipTextStyle,
    this.tooltipDecoration,
  });

  /// Resolves the provided [style] with the [defaultStyle].
  ///
  /// This method returns a new [ActionButtonStyle] instance where each property
  /// is taken from the provided [style] if it is not null, otherwise from the
  /// [defaultStyle].
  ///
  /// - [style]: The style to resolve. If null, the [defaultStyle] will be used.
  /// - [defaultStyle]: The default style to use for any properties not provided
  ///   by the [style].
  factory ActionButtonStyle.resolve(
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

  /// Provides default style for icon buttons.
  factory ActionButtonStyle.defaultStyle(ActionButtonType type) =>
      ActionButtonStyle.lightStyle(type);

  /// Provides a default dark style.
  factory ActionButtonStyle.darkStyle(ActionButtonType type) {
    final style = ActionButtonStyle.lightStyle(type);
    return ActionButtonStyle(
      icon: style.icon,
      iconColor: sh.invertColor(style.iconColor),
      iconDecoration: switch (type) {
        ActionButtonType.add ||
        ActionButtonType.record ||
        ActionButtonType.stop =>
          const BoxDecoration(
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

  /// Provides default light style for icon buttons.
  factory ActionButtonStyle.lightStyle(ActionButtonType type) {
    IconData icon;
    var color = FatColors.darkIcon;
    var bgColor = FatColors.lightButtonBackground;
    String tooltip;
    final tooltipTextStyle = FatTextStyles.tooltip;
    const tooltipDecoration = BoxDecoration(
      color: FatColors.tooltipBackground,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );

    switch (type) {
      case ActionButtonType.add:
        icon = FatIcons.add;
        tooltip = 'Add Attachment';
      case ActionButtonType.attachFile:
        icon = FatIcons.attach_file;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Attach File';
      case ActionButtonType.camera:
        icon = FatIcons.camera_alt;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Take Photo';
      case ActionButtonType.stop:
        icon = FatIcons.stop;
        tooltip = 'Stop';
      case ActionButtonType.close:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Close';
      case ActionButtonType.copy:
        icon = FatIcons.content_copy;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Copy to Clipboard';
      case ActionButtonType.edit:
        icon = FatIcons.edit;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Edit Message';
      case ActionButtonType.gallery:
        icon = FatIcons.image;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Image Gallery';
      case ActionButtonType.record:
        icon = FatIcons.mic;
        tooltip = 'Record Audio';
      case ActionButtonType.submit:
        icon = FatIcons.submit_icon;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        tooltip = 'Submit Message';
      case ActionButtonType.closeMenu:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.greyBackground;
        tooltip = 'Close Menu';
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
}
