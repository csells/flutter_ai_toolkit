// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'llm_provider_interface.dart';

class EchoProvider extends LlmProvider {
  EchoProvider({super.config});

  @override
  Stream<String> generateStream(String prompt) async* {
    await Future.delayed(const Duration(milliseconds: 500));
    yield 'echo: ';
    await Future.delayed(const Duration(milliseconds: 500));
    yield prompt;
  }
}
