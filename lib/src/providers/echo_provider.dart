// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_ai_toolkit/src/models/llm_config.dart';

import 'llm_provider_interface.dart';

class EchoProvider implements LlmProvider {
  EchoProvider(this.config);

  @override
  final LlmConfig config;

  @override
  Stream<String> generateStream(String prompt) async* {
    yield 'echo: ';
    // await Future.delayed(const Duration(seconds: 1)); // TODO: remove
    yield prompt;
  }
}
