// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../providers/llm_provider_interface.dart';
import 'view_styles.dart';

/// A widget that displays an attachment based on its type.
///
/// This widget determines the appropriate view for the given [attachment]
/// and renders it accordingly. It supports file attachments and image
/// attachments, but throws an exception for link attachments.
class AttachmentView extends StatelessWidget {
  /// Creates an AttachmentView.
  ///
  /// The [attachment] parameter must not be null.
  const AttachmentView(this.attachment, {super.key});

  /// The attachment to be displayed.
  final Attachment attachment;

  @override
  Widget build(BuildContext context) => switch (attachment) {
        // For file attachments, use a custom file attachment view
        (FileAttachment a) => _FileAttachmentView(a),
        // For image attachments, display the image aligned to the right
        (ImageAttachment a) => Align(
            alignment: Alignment.centerRight,
            child: Image.memory(a.bytes),
          ),
        // Link attachments are not supported in this implementation
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
          color: userMessageColor,
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
                color: placeholderTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(
                Icons.attach_file,
                color: iconColor,
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
                    style: body2TextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    attachment.mimeType,
                    style: body2TextStyle.copyWith(
                      color: placeholderTextColor,
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
