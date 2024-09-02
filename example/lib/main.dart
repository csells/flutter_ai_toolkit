import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'chat_page.dart';
import 'constants.dart';
import 'firebase_options.dart'; // from `flutterfire config`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  switch (providerType) {
    case ProviderType.firebaseVertext:
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    case ProviderType.googleGemini:
      await dotenv.load();
    case ProviderType.echo:
      break;
  }

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
