Hello and welcome to the Flutter AI Toolkit!

The AI Toolkit is a set of AI chat-related widgets to make it easy to add an AI chat window to your Flutter app. The AI Toolkit is organized around an abstract LLM provider API to make it easy to swap out the LLM provider that you'd like your chat provider to use. Out of the box, it comes with support for two LLM provider integrations: Google Gemini AI and Firebase Vertex AI.

## Current Alpha Features
The AI Toolkit is currently under active development and at the alpha stage, with the following features currently available:

- multi-turn chat (remembering context along the way)
- streaming responses
- multi-line chat text input (via Alt/Opt+Enter on web/desktop)
- cancel in-progress request
- edit the last prompt (starting with long-press as the UI gesture)
- rich text response display
- copy any response (starting with long-press as the UI gesture)
- multi-media attachments ([the web currently doesn't like file attachments](https://github.com/csells/flutter_ai_toolkit/issues/18), so they're disabled)
- handling structured LLM responses
- app-provided prompt suggestions
- pre-processing prompts to add prompt engineering, etc.
- pre-processing requests to enrich the output, e.g. host Flutter widgets
- swappable support for LLM providers; oob support for Gemini and Vertex
- support for all Flutter platforms, focusing initially on mobile and web

Here's an example of [a sample app](https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/gemini.dart) hosting the AI Tookit running on Android:

<img src="https://raw.githubusercontent.com/csells/flutter_ai_toolkit/main/README/screenshot.png" height="800"/>

If you'd like to see it in action, check out [the online demo](https://flutter-ai-toolkit-examp-60bad.web.app/).

## Getting started
Using the AI Toolkit is a matter of choosing which LLM provider you'd like to use (Gemini or Vertex), creating an instance and passing it to the `LlmChatView` widget, which is the main entry point for the AI Toolkit:

```dart
// don't forget the pubspec.yaml entries for these, too
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

... // app stuff here

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // create the chat view, passing in the Gemini provider
        body: LlmChatView(
          provider: GeminiProvider(
            model: 'gemini-1.5-flash',
            apiKey: googleApiKey,
          ),
        ),
      );
}
```

Here we're creating an instance of the `GeminiProvider`, configuring it as appropriate and passing it to an instance of the `LlmChatView`. That yields the screenshot above using Google Gemini AI as the LLM. You can see more details about configuring both the Gemini and Vertex LLM providers below.

## Gemini LLM Usage
To configure the `GeminiProvider` you two things:
1. model string, which you can ready about in [the Gemini models docs](https://ai.google.dev/gemini-api/docs/models/gemini), and 
1. an API key, which you can get [in Gemini AI Studio](https://aistudio.google.com/app/apikey).

With this in place, you're ready to write the Gemini code shown above. If you like, you can plug your API key and model string into the <a href="https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/gemini.dart">gemini.dart</a> sample. This sample has been tested on Android, iOS, the web and macOS, so give it a whirl.

Note: Be careful not to check your API key into a git repo or share it with anyone.

## Vertex LLM Usage
While Gemini AI is useful for quick prototyping, the recommended solution for production apps is Firebase Vertext AI. And the reason for that is that there's no good way to keep your Gemini API key safe -- if you ship your Flutter app with the API key in there, someone can figure out how to dig it out.

To solve this problem as well as many others that you're going to have in a real-world production app, the model for initializing an instance of the Vertex AI LLM provider doesn't have an API key. Instead, it relies on a Firebase project, which you then initialize in your app. You can do that with the steps described in [the Get started with the Gemini API using the Vertex AI in Firebase SDKs docs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter).

After following those instructions, you're ready to use Firebase Vertex AI in your project. Start by initializing Firebase:

```dart
// don't forget the pubspec.yaml entries for these, too
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

... // other imports

import 'firebase_options.dart'; // from `flutterfire config`

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

... // app stuff here
```

This is the exact same way that you'd initialize Firebase for use in any Flutter project, so it should be familiar to existing FlutterFire users.

Now you're ready to create an instance of the Vertex provider:

```dart
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        // create the chat view, passing in the Vertex provider
        body: LlmChatView(
          provider: VertexProvider(
            chatModel: FirebaseVertexAI.instance.generativeModel(
              model: 'gemini-1.5-flash',
            ),
          ),
        ),
      );
}
```
If you like, use your Firebase project with the <a href="https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/gemini.dart">vertex.dart</a> sample. This sample has also been tested on Android, iOS, the web and macOS.

Note: There's no API key; Firebase manages all of that for you in the Firebase project. However, in the same way that someone can reverse engineer the Gemini API key out of your Flutter code, they can do that with your Firebase project ID and related settings. To guard against that, check out [Firebase AppCheck](https://firebase.google.com/learn/pathways/firebase-app-check), which is beyond the scope of the sample code in this project.

## More Features Coming Soon!
As I mentioned, the AI Toolkit is just in the alpha phase of it's lifetime and it's under active development. Coming soon, you should expect the following features:
- updated UX based on Google design guidelines
- theming and styling support
- stand-alone chatbot app sample with multi-session support
- chat session serialization/deserialization
- dev-configured chatbot label + icon
- chat microphone speech-to-tech prompt input
- thoroughly tested multi-platform support, including Windows and Linux
- support for Cupertino as well as Material

## Feedback!
Along the way, as you use this package, please [log issues and feature requests](https://github.com/csells/flutter_ai_toolkit/issues) as well as any [code you'd like to contribute](https://github.com/csells/flutter_ai_toolkit/pulls). I want your feedback and your contributions to ensure that the AI Toolkit is just as robust and useful as it can be for your real apps.
