// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'llm_provider_interface.dart';

/// A simple LLM provider that echoes the input prompt and attachment
/// information.
///
/// This provider is primarily used for testing and debugging purposes.
class EchoProvider extends LlmProvider {
  @override

  /// Generates a stream of strings that echo the input prompt and attachment
  /// details.
  ///
  /// This method simulates a delay before responding, then yields the echo
  /// response in parts to mimic the behavior of a real LLM provider.
  ///
  /// [prompt] The input prompt to be echoed. [attachments] An optional iterable
  /// of attachments to be processed and included in the response.
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    await Future.delayed(const Duration(milliseconds: 1000));
    yield 'echo: ';
    await Future.delayed(const Duration(milliseconds: 1000));
    yield prompt;
    final strings = attachments.map(_stringFrom);
    yield '\n\nattachments: $strings';
  }

  String _stringFrom(Attachment attachment) => switch (attachment) {
        (ImageFileAttachment a) =>
          'image: ${a.mimeType}, ${a.bytes.length} bytes',
        (FileAttachment a) => 'file: ${a.mimeType}, ${a.bytes.length} bytes',
        (LinkAttachment a) => 'link: ${a.url}',
      };

  @override
  Future<List<double>> getDocumentEmbedding(String document) {
    throw UnimplementedError('EchoProvider.getDocumentEmbedding');
  }

  @override
  Future<List<double>> getQueryEmbedding(String query) {
    throw UnimplementedError('EchoProvider.getQueryEmbedding');
  }
}
