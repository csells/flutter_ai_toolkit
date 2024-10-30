// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../gemini_api_key.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Dark Mode';
  static final themeMode = ValueNotifier(ThemeMode.dark);

  const App({super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (BuildContext context, ThemeMode mode, Widget? child) =>
            MaterialApp(
          title: title,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          home: ChatPage(),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _provider = GeminiProvider(
    generativeModel: GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: geminiApiKey,
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(App.title),
          actions: [
            IconButton(
              onPressed: () => App.themeMode.value =
                  App.themeMode.value == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light,
              icon: const Icon(Icons.brightness_4_outlined),
            ),
          ],
        ),
        body: LlmChatView(
          provider: _provider,
          style: App.themeMode.value == ThemeMode.dark
              ? LlmChatViewStyle.darkStyle()
              : LlmChatViewStyle.lightStyle(),
        ),
      );
}
