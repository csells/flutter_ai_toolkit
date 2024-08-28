import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'chat_page.dart';

void main() async {
  await dotenv.load();
  runApp(const App());
}

class App extends StatelessWidget {
  static const title = 'LLM Chat Example';

  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: title,
        home: const ChatPage(),
        themeMode: ThemeMode.system,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
      );
}
