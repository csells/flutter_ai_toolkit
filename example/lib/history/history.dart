// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main(List<String> args) async => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: History';

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        home: ChatPage(),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final _provider = GeminiProvider(
  //   generativeModel: GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: geminiApiKey,
  //   ),
  // );
  final _controller = LlmChatViewController(provider: EchoProvider());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onHistoryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onHistoryChanged);
    super.dispose();
  }

  void _onHistoryChanged() {
    final history = _controller.history.toList();
    // ignore: prefer_is_empty
    final llmIndex = history.length < 1 ? -1 : history.length - 1;
    final userIndex = history.length < 2 ? -1 : history.length - 2;
    final llm = llmIndex == -1 ? null : history[llmIndex];
    final user = userIndex == -1 ? null : history[userIndex];
    debugPrint(''
        'USER: ${user?.text}\n'
        'LLM: ${llm?.text}\n'
        '');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          controller: _controller,
        ),
      );
}
