// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_provider_interface.dart';

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required String model,
    required String apiKey,
    GenerationConfig? config,
  }) {
    // output to the Debug console
    debugPrint(
      'GeminiProvider: '
      'topK= ${config?.topK ?? 'null'}, '
      'temp= ${config?.temperature ?? 'null'}',
    );

    final llm = GenerativeModel(
      model: model,
      apiKey: apiKey,
      generationConfig: config,
    );

    _chat = llm.startChat(); // TODO: history
  }

  late final ChatSession _chat;

  @override
  Stream<String> generateStream(String prompt) async* {
    final response = _chat.sendMessageStream(Content.text(prompt));
    await for (final chunk in response) {
      try {
        final text = chunk.text;
        if (text != null) yield text;
      } on Exception catch (ex) {
        yield 'ERROR: ${ex.toString()}';
      }
    }
  }
}
