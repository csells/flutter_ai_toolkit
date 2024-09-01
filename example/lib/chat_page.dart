import 'package:firebase_vertexai/firebase_vertexai.dart' as vertex;
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as gemini;

import 'configuration_panel.dart';
import 'constants.dart';
import 'main.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // number of tokens to be sampled from for each decoding step
  var _topK = 40;

  // max tokens for the generated output
  var _maxTokens = 1024;

  // randomness when decoding the next token
  var _temp = 0.8;

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
              updateMaxTokens: (val) => setState(() => _maxTokens = val),
            ),
          ),
        ),
        body: LlmChatView(
          provider: kTesting
              ? EchoProvider()
              : kUseFirebase
                  ? FirebaseVertexProvider(
                      model: 'gemini-1.5-flash',
                      config: vertex.GenerationConfig(
                        topK: _topK,
                        temperature: _temp,
                        maxOutputTokens: _maxTokens,
                      ),
                    )
                  : GeminiProvider(
                      model: 'gemini-1.5-flash',
                      apiKey: dotenv.get('GEMINI_API_KEY'),
                      config: gemini.GenerationConfig(
                        topK: _topK,
                        temperature: _temp,
                        maxOutputTokens: _maxTokens,
                      ),
                    ),
        ),
      );
}
