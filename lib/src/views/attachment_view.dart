import 'package:flutter/material.dart';

import '../providers/llm_provider_interface.dart';
import 'view_styles.dart';

class AttachmentView extends StatelessWidget {
  const AttachmentView(this.attachment, {super.key});
  final Attachment attachment;

  @override
  Widget build(BuildContext context) => switch (attachment) {
        (FileAttachment a) => _FileAttachmentView(a),
        (ImageAttachment a) => Align(
            alignment: Alignment.centerRight,
            child: Image.memory(a.bytes),
          ),
        (LinkAttachment _) => throw Exception('Link attachments not supported'),
      };
}

class _FileAttachmentView extends StatelessWidget {
  const _FileAttachmentView(this.attachment);
  final FileAttachment attachment;

  @override
  Widget build(BuildContext context) => Container(
        height: 80,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: unnamedColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: ShapeDecoration(
                color: placeholderTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.attach_file, color: iconColor, size: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(attachment.name, style: body2TextStyle),
                  Text(
                    attachment.mimeType,
                    style: body2TextStyle.copyWith(
                      color: placeholderTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}