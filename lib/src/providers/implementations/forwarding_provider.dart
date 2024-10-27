// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../interface/attachments.dart';
import '../interface/llm_provider.dart';

/// A provider class that forwards the generation of text to a user-provided
/// function.
class ForwardingProvider extends LlmProvider {
  /// Creates a new instance of [ForwardingProvider].
  ///
  /// [messageSender] is a function that takes a [String] prompt and an
  /// optional [Iterable<Attachment>] attachments and returns a [Stream<String>]
  /// containing the generated text.
  ForwardingProvider({required this.provider, required this.messageSender});

  /// The underlying LLM provider that this [ForwardingProvider] wraps.
  ///
  /// This provider is used for operations that are not handled by the
  /// [messageSender], such as generating embeddings.
  final LlmProvider provider;

  /// The function used to generate the stream of text.
  ///
  /// This function takes a [String] prompt and an optional
  /// [Iterable<Attachment>] attachments, and returns a [Stream<String>]
  /// containing the generated text.
  final LlmStreamGenerator messageSender;

  @override
  Future<List<double>> getDocumentEmbedding(String document) =>
      provider.getDocumentEmbedding(document);

  @override
  Future<List<double>> getQueryEmbedding(String query) =>
      provider.getQueryEmbedding(query);

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) =>
      provider.generateStream(prompt, attachments: attachments);

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) =>
      messageSender(prompt, attachments: attachments);
}
