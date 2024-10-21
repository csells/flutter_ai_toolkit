// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main(List<String> args) async => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Cupertino';

  const App({super.key});

  @override
  Widget build(BuildContext context) => const CupertinoApp(
        title: title,
        home: ChatPage(),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(App.title),
        ),
        child: LlmChatView(
          provider: GeminiProvider(
            generativeModel: GenerativeModel(
              model: 'gemini-1.5-flash',
              apiKey: geminiApiKey,
            ),
          ),
        ),
      );
}
