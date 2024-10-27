import 'package:flutter/widgets.dart';

import '../../dialogs/adaptive_dialog.dart';
import '../../dialogs/image_preview_dialog.dart';
import '../../providers/llm_provider_interface.dart';

/// A widget that displays an image attachment.
///
/// This widget aligns the image to the center-right of its parent and
/// allows the user to tap on the image to open a preview dialog.
class ImageAttachmentView extends StatelessWidget {
  /// Creates an ImageAttachmentView.
  ///
  /// The [attachment] parameter must not be null and represents the
  /// image file attachment to be displayed.
  const ImageAttachmentView(this.attachment, {super.key});

  /// The image file attachment to be displayed.
  final ImageFileAttachment attachment;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
            onTap: () => AdaptiveAlertDialog.show<void>(
                  context: context,
                  barrierDismissible: true,
                  content: ImagePreviewDialog(attachment),
                ),
            child: Image.memory(attachment.bytes)),
      );
}
