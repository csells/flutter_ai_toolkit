// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';

import 'llm_provider_interface.dart';

/// A provider class for interacting with Firebase Vertex AI's language model.
///
/// This class extends [LlmProvider] and implements the necessary methods to
/// generate text using Firebase Vertex AI's generative model.
class FirebaseVertexProvider extends LlmProvider {
  /// Creates a new instance of [FirebaseVertexProvider].
  ///
  /// [model] is the name of the Firebase Vertex AI model to use. [config] is an
  /// optional [GenerationConfig] to customize the text generation.
  FirebaseVertexProvider({
    required String model,
    String? systemInstruction,
    GenerationConfig? config,
  }) {
    final llm = FirebaseVertexAI.instance.generativeModel(
      model: model,
      generationConfig: config,
      systemInstruction:
          systemInstruction != null ? Content.system(systemInstruction) : null,
    );

    _chat = llm.startChat();
  }

  /// The chat session used for generating responses.
  late final ChatSession _chat;

  @override
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
        (_) => throw UnsupportedError(''
            'Unsupported attachment type: '
            '${attachment.runtimeType}'
            ''),
      };
}
