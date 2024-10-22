import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../flutter_ai_toolkit.dart';
import '../utility.dart';
import 'circle_button.dart';
import 'fat_colors_styles.dart';

/// Displays a dialog to preview the image when the user taps on an attached
/// image.
class ImagePreviewDialog extends StatelessWidget {
  /// Shows the [ImagePreviewDialog] for the given [attachment].
  const ImagePreviewDialog(this.attachment, {super.key});

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
  static Future<void> show(
    BuildContext context,
    ImageFileAttachment attachment,
  ) =>
      isCupertinoApp(context)
          ? showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                content: ImagePreviewDialog(attachment),
              ),
            )
          : showDialog(
              context: context,
              builder: (context) => Dialog(
                insetPadding: const EdgeInsets.all(12),
                backgroundColor: FatColors.transparent,
                child: ImagePreviewDialog(attachment),
              ),
            );

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.topRight,
        children: [
          Image.memory(attachment.bytes, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: CircleButton(
                icon: Icons.close,
                size: 24,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      );
}
