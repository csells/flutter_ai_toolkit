// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

late final SharedPreferences prefs;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(App(prefs: prefs));
}

class App extends StatefulWidget {
  static const title = 'Demo: Flutter AI Toolkit';

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
                googleApiKey: _googleApiKey!,
                onResetApiKey: _resetApiKey,
              ),
      );

  void _setApiKey(String apiKey) {
    setState(() => _googleApiKey = apiKey);
    widget.prefs.setString('google_api_key', apiKey);
  }

  void _resetApiKey() {
    setState(() => _googleApiKey = null);
    widget.prefs.remove('google_api_key');
  }
}

class GoogleApiKeyPage extends StatefulWidget {
  const GoogleApiKeyPage({
    required this.title,
    required this.onApiKey,
    super.key,
  });

  final String title;
  final void Function(String apiKey) onApiKey;

  @override
  State<GoogleApiKeyPage> createState() => _GoogleApiKeyPageState();
}

class _GoogleApiKeyPageState extends State<GoogleApiKeyPage> {
  static final url = Uri.parse('https://aistudio.google.com/app/apikey');
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
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
  const ChatPage({
    required this.googleApiKey,
    required this.onResetApiKey,
    super.key,
  });

  final String googleApiKey;
  final void Function() onResetApiKey;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Reset API Key'),
                onTap: () {
                  onResetApiKey();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: LlmChatView(
          provider: GeminiProvider(
            model: 'gemini-1.5-flash',
            apiKey: googleApiKey,
          ),
        ),
      );
}
