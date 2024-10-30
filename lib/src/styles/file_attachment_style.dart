// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

import 'fat_colors.dart';
import 'fat_icons.dart';
import 'fat_text_styles.dart';
import 'style_helpers.dart' as sh;

/// Style for file attachments in the chat view.
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
        color: FatColors.greyBackground,
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
      filetypeStyle: style.filetypeStyle!.copyWith(color: FatColors.black),
    );
  }

  /// Provides a default style.
  factory FileAttachmentStyle.defaultStyle() =>
      FileAttachmentStyle.lightStyle();

  /// Provides a default light style.
  factory FileAttachmentStyle.lightStyle() => FileAttachmentStyle(
        decoration: ShapeDecoration(
          color: FatColors.fileContainerBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: FatIcons.attach_file,
        iconColor: FatColors.darkIcon,
        iconDecoration: ShapeDecoration(
          color: FatColors.fileAttachmentIconBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        filenameStyle: FatTextStyles.filename,
        filetypeStyle: FatTextStyles.filetype,
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
