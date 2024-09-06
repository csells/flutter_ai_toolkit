import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/google_api_key_page.dart';

late final SharedPreferences prefs;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Check for /reset command line argument
  if (args.contains('/reset')) {
    await prefs.remove('google_api_key');
  }

  runApp(App(prefs: prefs));
}

class App extends StatefulWidget {
  static const title = 'Example: Google Gemini AI';

  const App({super.key, required this.prefs});
  final SharedPreferences prefs;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? _googleApiKey;

  @override
  void initState() {
    super.initState();
    _googleApiKey = widget.prefs.getString('google_api_key');
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: App.title,
        home: _googleApiKey == null
            ? GoogleApiKeyPage(
                title: App.title,
                onApiKey: _setApiKey,
              )
            : ChatPage(
                provider: GeminiProvider(
                  model: 'gemini-1.5-flash',
                  apiKey: _googleApiKey!,
                ),
              ),
      );

  void _setApiKey(String apiKey) {
    setState(() => _googleApiKey = apiKey);
    widget.prefs.setString('google_api_key', apiKey);
  }
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
