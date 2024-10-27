import 'package:flutter/widgets.dart';

import '../fat_icons.dart';
import 'action_button_type.dart';
import 'fat_color.dart';

/// Style for icon buttons.
class ActionButtonStyle {
  /// The icon to display for the icon button.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// Creates an IconButtonStyle.
  const ActionButtonStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
  });

  /// Provides default style for icon buttons.
  static ActionButtonStyle defaultStyle(ActionButtonType type) {
    IconData icon;
    var color = FatColor.darkIcon;
    var bgColor = FatColor.lightButtonBackground;

    switch (type) {
      case ActionButtonType.add:
        icon = FatIcons.add;
        break;
      case ActionButtonType.attachFile:
        icon = FatIcons.attach_file;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.camera:
        icon = FatIcons.camera_alt;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.cancel:
        icon = FatIcons.stop;
        break;
      case ActionButtonType.close:
        icon = FatIcons.close;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.copy:
        icon = FatIcons.content_copy;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.edit:
        icon = FatIcons.edit;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.gallery:
        icon = FatIcons.image;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.record:
        icon = FatIcons.mic;
        break;
      case ActionButtonType.submit:
        icon = FatIcons.submit_icon;
        color = FatColor.whiteIcon;
        bgColor = FatColor.darkButtonBackground;
        break;
      case ActionButtonType.closeMenu:
        icon = FatIcons.close;
        color = FatColor.whiteIcon;
        bgColor = FatColor.greyBackground;
        break;
    }

    return ActionButtonStyle(
      icon: icon,
      iconColor: color,
      iconDecoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
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
  }) {
    return ActionButtonStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
    );
  }
}
