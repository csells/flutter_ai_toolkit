import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart'; // from `flutterfire config`

const kUseFirebase = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kUseFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await dotenv.load();
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
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
      );
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final LlmProvider provider;

  @override
  void initState() {
    super.initState();
    provider = _initProvider();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(() {
      fn();
      provider = _initProvider();
    });
  }

  LlmProvider _initProvider() => kUseFirebase
      ? FirebaseVertexProvider(
          model: 'gemini-1.5-flash',
        )
      : GeminiProvider(
          model: 'gemini-1.5-flash',
          apiKey: dotenv.get('GEMINI_API_KEY'),
        );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${App.title} - ${provider.displayName}'),
        ),
        body: LlmChatView(provider: provider),
      );
}
