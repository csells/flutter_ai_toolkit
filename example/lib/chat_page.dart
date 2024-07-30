import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import 'configuration_panel.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _config = LlmConfig();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: InferenceConfigurationPanel(
              topK: _config.topK,
              temp: _config.temp,
              maxTokens: _config.maxTokens,
              updateTopK: (val) => setState(() => _config.topK = val),
              updateTemp: (val) => setState(() => _config.temp = val),
              updateMaxTokens: (val) => setState(() => _config.maxTokens = val),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LlmChatView(GeminiProvider(
            model: 'gemini-1.5-flash',
            apiKey: Platform.environment['GEMINI_API_KEY']!,
            config: _config,
          )),
        ),
      );
}
