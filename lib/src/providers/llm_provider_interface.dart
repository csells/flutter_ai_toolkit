// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

sealed class Attachment {}

final class DataAttachment implements Attachment {
  final String mimeType;
  final Uint8List bytes;
  DataAttachment({required this.mimeType, required this.bytes});
}

final class FileAttachment implements Attachment {
  final Uri url;
  FileAttachment({required this.url});
}

abstract class LlmProvider {
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });
}
