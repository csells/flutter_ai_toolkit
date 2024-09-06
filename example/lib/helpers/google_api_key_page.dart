import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

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
