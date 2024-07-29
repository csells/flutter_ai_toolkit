// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

abstract class LlmProvider {
  LlmConfig get config;
  Stream<String> generateStream(String prompt);
}
