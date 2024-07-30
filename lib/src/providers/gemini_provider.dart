// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:google_generative_ai/google_generative_ai.dart';

import 'llm_provider_interface.dart';

class GeminiProvider extends LlmProvider {
  GeminiProvider({
    required this.model,
    required this.apiKey,
    super.config,
  });

  final String model;
  final String apiKey;

  @override
  Stream<String> generateStream(String prompt) async* {
    final llm = GenerativeModel(model: model, apiKey: apiKey);
    final content = [Content.text(prompt)];
    await for (final chunk in llm.generateContentStream(content)) {
      final text = chunk.text;
      if (text != null) yield text;
    }
  }
}
