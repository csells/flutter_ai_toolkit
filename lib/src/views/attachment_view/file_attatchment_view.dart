import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../providers/llm_provider_interface.dart';
import '../../styles/fat_colors.dart';
import '../../styles/fat_icons.dart';
import '../../styles/fat_text_styles.dart';

/// A widget that displays a file attachment.
///
/// This widget creates a container with a file icon and information about the
/// attached file, such as its name and MIME type.
class FileAttachmentView extends StatelessWidget {
  /// Creates a FileAttachmentView.
  ///
  /// The [attachment] parameter must not be null and represents the
  /// file attachment to be displayed.
  const FileAttachmentView(this.attachment, {super.key});

  /// The file attachment to be displayed.
  final FileAttachment attachment;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: FatColors.userMessageBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: FatColors.hintText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(
                FatIcons.attach_file,
                color: FatColors.darkIcon,
                size: 24,
              ),
            ),
            const Gap(8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    attachment.name,
                    style: FatTextStyles.body2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    attachment.mimeType,
                    style: FatTextStyles.body2.copyWith(
                      color: FatColors.hintText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
