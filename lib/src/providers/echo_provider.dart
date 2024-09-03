// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'llm_provider_interface.dart';

class EchoProvider extends LlmProvider {
  @override
  String get displayName => 'Echo (Testing)';

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    await Future.delayed(const Duration(milliseconds: 1000));
    yield 'echo: ';
    await Future.delayed(const Duration(milliseconds: 500));
    yield prompt;
    final strings = attachments.map(_stringFrom);
    yield '\n\nattachments: $strings';
  }

  String _stringFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => 'data: ${a.mimeType}, ${a.bytes.length} bytes',
        (ImageAttachment a) => 'image: ${a.mimeType}, ${a.bytes.length} bytes',
        (LinkAttachment a) => 'file: ${a.url}',
      };
}
