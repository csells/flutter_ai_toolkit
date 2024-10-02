import 'package:flutter/material.dart';
import '../../flutter_ai_toolkit.dart';
import 'circle_button.dart';

/// Displays a dialog to preview the image when the user taps on an attached image.
///
/// This dialog will only be shown if the provided [attachment] is of type
/// [ImageFileAttachment]
void showImagePreviewDialog(BuildContext context, Attachment attachment) {
  if (attachment is ImageFileAttachment) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        backgroundColor: Colors.transparent,
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
}