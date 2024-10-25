// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main(List<String> args) async => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Custom Styles';
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        ),
        home: ChatPage(),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // TODO: uncomment this to use Gemini
  // final provider = GeminiProvider(
  //   generativeModel: GenerativeModel(
  //     model: 'gemini-1.5-flash',
  //     apiKey: geminiApiKey,
  //   ),
  // );
  final provider = EchoProvider();
  final transcript = List<LlmChatMessage>.empty(growable: true);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset(
                'assets/halloween-bg.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.25),
              ),
            ),
            LlmChatView(
              provider: provider,
              transcript: transcript,
              style: LlmChatViewStyle(
                backgroundColor: Colors.transparent,
                llmMessageStyle: LlmMessageStyle(
                  icon: Icons.sentiment_very_satisfied,
                  iconColor: Colors.black,
                  iconDecoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topRight: Radius.zero,
                      bottomRight: Radius.circular(8),
                    ),
                    border: Border.all(color: Colors.black),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepOrange.shade900,
                        Colors.orange.shade800,
                        Colors.purple.shade900,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  markdownStyle: MarkdownStyleSheet(
                    p: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
