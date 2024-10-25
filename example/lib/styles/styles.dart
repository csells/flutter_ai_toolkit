// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';

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
        debugShowCheckedModeBanner: false,
        home: ChatPage(),
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  LlmProvider? _provider;
  List<LlmChatMessage>? _transcript;

  late final _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1,
  );

  late final _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  );

  TextStyle get _creepsterStyle => GoogleFonts.creepster(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    // TODO: uncomment this to use Gemini
    // _provider = GeminiProvider(
    //   generativeModel: GenerativeModel(
    //     model: 'gemini-1.5-flash',
    //     apiKey: geminiApiKey,
    //   ),
    // );
    _provider = EchoProvider();
    _transcript = List<LlmChatMessage>.empty(growable: true);
    _controller
      ..value = 1.0
      ..reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(App.title),
          actions: [
            IconButton(
              onPressed: reset,
              icon: const Icon(Icons.edit_note),
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: FadeTransition(
                  opacity: _animation,
                  child: Image.asset(
                    'assets/halloween-bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              LlmChatView(
                provider: _provider!,
                transcript: _transcript,
                style: LlmChatViewStyle(
                  backgroundColor: Colors.transparent,
                  inputBoxStyle: InputBoxStyle(
                    backgroundColor: _animation.isAnimating
                        ? Colors.transparent
                        : Colors.black,
                  ),
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
                      p: _creepsterStyle,
                      listBullet: _creepsterStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
