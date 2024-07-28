import 'package:flutter/material.dart';

import 'chat_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  static const title = 'LLM Chat Example';

  const App({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: title,
        home: ChatPage(),
      );
}
