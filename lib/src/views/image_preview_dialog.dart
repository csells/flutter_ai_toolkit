import 'package:flutter/material.dart';

import '../../flutter_ai_toolkit.dart';
import 'circle_button.dart';
import 'view_styles.dart';

/// Displays a dialog to preview the image when the user taps on an attached
/// image.
class ImagePreviewDialog {
  /// Shows the [ImagePreviewDialog] for the given [attachment].
  const ImagePreviewDialog(this.attachment);

  /// The image file attachment to be previewed in the dialog.
  final ImageFileAttachment attachment;

  /// Shows the [ImagePreviewDialog] for the given [attachment].
  ///
  /// This method creates and shows a dialog containing an image preview.
  ///
  /// Parameters:
  ///   * [context]: The build context in which to show the dialog.
  ///   * [attachment]: The [ImageFileAttachment] to be previewed.
  ///
  /// Returns a [Future] that completes when the dialog is dismissed.
  Future<void> show(BuildContext context) => showDialog(
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(12),
          backgroundColor: FatColors.transparent,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Image.memory(attachment.bytes, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleButton(
                  icon: Icons.close,
                  size: 24,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
}
