// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'style_helpers.dart' as sh;
import 'tookit_icons.dart';
import 'toolkit_colors.dart';
import 'toolkit_text_styles.dart';

/// Style for file attachments in the chat view.
@immutable
class FileAttachmentStyle {
  /// Creates a FileAttachmentStyle.
  const FileAttachmentStyle({
    this.decoration,
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.filenameStyle,
    this.filetypeStyle,
  });

  /// Resolves the FileAttachmentStyle by combining the provided style with
  /// default values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses
  /// [FileAttachmentStyle.defaultStyle].
  ///
  /// [style] - The custom FileAttachmentStyle to apply. Can be null.
  /// [defaultStyle] - The default FileAttachmentStyle to use as a base. If
  /// null, uses [FileAttachmentStyle.defaultStyle].
  ///
  /// Returns a new [FileAttachmentStyle] instance with resolved properties.
  factory FileAttachmentStyle.resolve(
    FileAttachmentStyle? style, {
    FileAttachmentStyle? defaultStyle,
  }) {
    defaultStyle ??= FileAttachmentStyle.defaultStyle();
    return FileAttachmentStyle(
      decoration: style?.decoration ?? defaultStyle.decoration,
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
      filenameStyle: style?.filenameStyle ?? defaultStyle.filenameStyle,
      filetypeStyle: style?.filetypeStyle ?? defaultStyle.filetypeStyle,
    );
  }

  /// Provides a default dark style.
  factory FileAttachmentStyle.darkStyle() {
    final style = FileAttachmentStyle.lightStyle();
    return FileAttachmentStyle(
      // inversion doesn't look great here
      // decoration: sh.invertDecoration(style.decoration),
      decoration: ShapeDecoration(
        color: ToolkitColors.greyBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: style.icon,
      iconColor: sh.invertColor(style.iconColor),
      iconDecoration: sh.invertDecoration(style.iconDecoration),
      filenameStyle: sh.invertTextStyle(style.filenameStyle),
      // inversion doesn't look great here
      // filetypeStyle: sh.invertTextStyle(style.filetypeStyle),
      filetypeStyle: style.filetypeStyle!.copyWith(color: ToolkitColors.black),
    );
  }

  /// Provides a default style.
  factory FileAttachmentStyle.defaultStyle() =>
      FileAttachmentStyle.lightStyle();

  /// Provides a default light style.
  factory FileAttachmentStyle.lightStyle() => FileAttachmentStyle(
        decoration: ShapeDecoration(
          color: ToolkitColors.fileContainerBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: ToolkitIcons.attach_file,
        iconColor: ToolkitColors.darkIcon,
        iconDecoration: ShapeDecoration(
          color: ToolkitColors.fileAttachmentIconBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        filenameStyle: ToolkitTextStyles.filename,
        filetypeStyle: ToolkitTextStyles.filetype,
      );

  /// The decoration for the file attachment container.
  final Decoration? decoration;

  /// The icon to display for the file attachment.
  final IconData? icon;

  /// The color of the file attachment icon.
  final Color? iconColor;

  /// The decoration for the file attachment icon container.
  final Decoration? iconDecoration;

  /// The text style for the filename.
  final TextStyle? filenameStyle;

  /// The text style for the filetype.
  final TextStyle? filetypeStyle;
}
