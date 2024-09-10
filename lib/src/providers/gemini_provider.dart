// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_provider_interface.dart';

/// A provider class for interacting with Google's Gemini AI language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using the Gemini AI model.
class GeminiProvider extends LlmProvider {
  /// Creates a new instance of [GeminiProvider].
  ///
  /// [model] is the name of the Gemini AI model to use. [apiKey] is the API key
  /// for authentication with the Gemini AI service. [config] is an optional
  /// [GenerationConfig] to customize the text generation.
  GeminiProvider({
    required String model,
    required String apiKey,
    String? systemInstruction,
    GenerationConfig? config,
  }) {
    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: config,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat();
  }

  late final ChatSession _chat;

  @override

  /// Generates a stream of text based on the given prompt and attachments.
  ///
  /// [prompt] is the input text to generate a response for. [attachments] is an
  /// optional iterable of [Attachment] objects to include with the prompt.
  ///
  /// Returns a [Stream] of [String] containing the generated text chunks.
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map(_partFrom),
    ]);
    final response = _chat.sendMessageStream(content);
    await for (final chunk in response) {
      final text = chunk.text;
      if (text != null) yield text;
    }
  }

  Part _partFrom(Attachment attachment) => switch (attachment) {
        (FileAttachment a) => DataPart(a.mimeType, a.bytes),
        (ImageAttachment a) => DataPart(a.mimeType, a.bytes),
        (LinkAttachment a) => FilePart(a.url),
      };
}
