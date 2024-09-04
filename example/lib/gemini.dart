import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
            ? ApiKeyPage(onApiKey: _setApiKey)
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

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({
    required this.onApiKey,
    super.key,
  });

  final void Function(String apiKey) onApiKey;

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  static final url = Uri.parse('https://aistudio.google.com/app/apikey');
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (context, value, child) => Column(
              children: [
                const Text('To run this sample, you need a Google API key.\n'
                    'Get your Google API Key from the following URL:'),
                GestureDetector(
                  onTap: () => launchUrl(url),
                  child: Text(
                    url.toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Gap(16),
                const Text('Paste your API key here:'),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Google API Key',
                      errorText: _isValidApiKey()
                          ? null
                          : 'API key must be 39 characters',
                    ),
                    onSubmitted: _isValidApiKey()
                        ? (apiKey) => widget.onApiKey(apiKey)
                        : null,
                  ),
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: _isValidApiKey()
                      ? () => widget.onApiKey(_controller.text)
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );

  bool _isValidApiKey() => _controller.text.length == 39;
}

class ChatPage extends StatelessWidget {
  const ChatPage({required this.provider, super.key});
  final LlmProvider provider;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${App.title} - ${provider.displayName}'),
        ),
        body: LlmChatView(provider: provider),
      );
}
