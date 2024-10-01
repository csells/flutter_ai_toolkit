// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main(List<String> args) async => runApp(_App());

class _App extends StatelessWidget {
  static const title = 'Example: Echo Test';

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(title: const Text(title)),
          body: LlmChatView(provider: EchoProvider()),
        ),
      );
}
