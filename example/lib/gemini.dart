import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

void main(List<String> args) async => runApp(const App());

class App extends StatelessWidget {
  static const title = 'Example: Google Gemini AI';
  final String _googleApiKey = 'TODO: Set your Google API key';

  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        home: ChatPage(
          provider: GeminiProvider(
            model: 'gemini-1.5-flash',
            apiKey: _googleApiKey,
          ),
        ),
      );
}

class ChatPage extends StatelessWidget {
  const ChatPage({required this.provider, super.key});
  final LlmProvider provider;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(provider: provider),
      );
}
