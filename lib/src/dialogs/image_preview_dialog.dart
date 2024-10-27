import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../flutter_ai_toolkit.dart';

/// Displays a dialog to preview the image when the user taps on an attached
/// image.
class ImagePreviewDialog extends StatelessWidget {
  /// Shows the [ImagePreviewDialog] for the given [attachment].
  const ImagePreviewDialog(this.attachment, {super.key});

  /// The image file attachment to be previewed in the dialog.
  final ImageFileAttachment attachment;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Image.memory(attachment.bytes, fit: BoxFit.contain),
        ),
      );
}
