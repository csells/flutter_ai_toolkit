// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_vertexai/firebase_vertexai.dart';

import 'llm_provider_interface.dart';

class FirebaseVertexProvider extends LlmProvider {
  @override
  String get displayName => 'Firebase Vertex AI';

  FirebaseVertexProvider({
    required String model,
    GenerationConfig? config,
  }) {
    final llm = FirebaseVertexAI.instance.generativeModel(
      model: model,
      generationConfig: config,
    );

    _chat = llm.startChat();
  }

  late final ChatSession _chat;

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final content = Content('user', [
      TextPart(prompt),
      ...attachments.map((a) => _partFrom(a)),
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
