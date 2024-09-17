// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'llm_provider_interface.dart';

/// A provider class that forwards the generation of text to a user-provided
/// function.
class ForwardingProvider extends LlmProvider {
  /// Creates a new instance of [ForwardingProvider].
  ///
  /// [streamGenerator] is a function that takes a [String] prompt and an
  /// optional [Iterable<Attachment>] attachments and returns a [Stream<String>]
  /// containing the generated text.
  ForwardingProvider({required this.streamGenerator});

  /// The function used to generate the stream of text.
  ///
  /// This function takes a [String] prompt and an optional
  /// [Iterable<Attachment>] attachments, and returns a [Stream<String>]
  /// containing the generated text.
  final LlmStreamGenerator streamGenerator;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) =>
      streamGenerator(prompt, attachments: attachments);
}
