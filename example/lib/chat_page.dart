import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'configuration_panel.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // number of tokens to be sampled from for each decoding step
  int _topK = 40;

  // context size window for the LLM
  final int _maxTokens = 1024;

  // randomness when decoding the next token
  double _temp = 0.8;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: InferenceConfigurationPanel(
              topK: _topK,
              temp: _temp,
              maxTokens: _maxTokens,
              updateTopK: (val) => setState(() => _topK = val),
              updateTemp: (val) => setState(() => _temp = val),
              // NOTE: not used for Gemini
              // updateMaxTokens: (val) => setState(() => _maxTokens = val),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LlmChatView(
            // EchoProvider(),
            GeminiProvider(
              model: 'gemini-1.5-flash',
              apiKey: Platform.environment['GEMINI_API_KEY']!,
              config: GenerationConfig(
                // NOTE: no config for max tokens
                topK: _topK,
                temperature: _temp,
              ),
            ),
          ),
        ),
      );
}
