// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:mime/mime.dart';

sealed class Attachment {
  const Attachment({required this.name});
  final String name;

  static String _mimeType(XFile file) =>
      file.mimeType ?? lookupMimeType(file.path) ?? 'application/octet-stream';
}

final class FileAttachment extends Attachment {
  final String mimeType;
  final Uint8List bytes;
  FileAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  static Future<FileAttachment> fromFile(XFile file) async => FileAttachment(
        name: file.name,
        mimeType: Attachment._mimeType(file),
        bytes: await file.readAsBytes(),
      );
}

final class ImageAttachment extends Attachment {
  final String mimeType;
  final Uint8List bytes;
  ImageAttachment({
    required super.name,
    required this.mimeType,
    required this.bytes,
  });

  static Future<ImageAttachment> fromFile(XFile file) async {
    final mimeType = Attachment._mimeType(file);
    if (!mimeType.toLowerCase().startsWith('image/')) {
      throw Exception('Not an image: $mimeType');
    }

    return ImageAttachment(
      name: file.name,
      mimeType: mimeType,
      bytes: await file.readAsBytes(),
    );
  }
}

final class LinkAttachment extends Attachment {
  final Uri url;
  LinkAttachment({required super.name, required this.url});
}

abstract class LlmProvider {
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments,
  });
}
