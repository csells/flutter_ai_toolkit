Hello and welcome to the Flutter AI Toolkit!

The AI Toolkit is a set of AI chat-related widgets to make it easy to add an AI chat window to your Flutter app. The AI Toolkit is organized around an abstract LLM provider API to make it easy to swap out the LLM provider that you'd like your chat provider to use. Out of the box, it comes with support for two LLM provider integrations: Google Gemini AI and Firebase Vertex AI.

## Alpha Features
The AI Toolkit is currently under active development and at the alpha stage, with the following features currently available:

- multi-turn chat (remembering context along the way)
- streaming responses
- multi-line chat text input (via Alt/Opt+Enter on web/desktop)
- cancel in-progress request
- edit the last prompt (starting with long-press as the UI gesture)
- rich text response display
- copy any response (starting with long-press as the UI gesture)
- multi-media attachments ([the web currently doesn't like file attachments](https://github.com/csells/flutter_ai_toolkit/issues/18), so they're disabled)
- swappable support for LLM providers; oob support for Gemini and Vertex
- support for all Flutter platforms, focusing initially on mobile and web

Here's an example of [a sample app](example/lib/gemini.dart) hosting the AI Tookit running on Android:

<img src="https://raw.githubusercontent.com/csells/flutter_ai_toolkit/main/README/screenshot.png" height="800"/>

If you'd like to see it in action, check out [the online demo](https://flutter-ai-toolkit-examp-60bad.web.app/).

## Getting started
Using the AI Toolkit is a matter of choosing which LLM provider you'd like to use (Gemini or Vertex), creating an instance and passing it to the `LlmChatView` widget, which is the main entry point for the AI Toolkit:

```dart
// don't forget the pubspec.yaml entry, too
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

With this in place, you're ready to write the Gemini code shown above. If you like, you can plug your API key and model string into the <a href="example/lib/gemini.dart">gemini.dart</a> sample. This sample has been tested on Android, iOS, the web and macOS, so give it a whirl.

Note: Be careful not to check your API key into a git repo or share it with anyone.

## Vertex LLM Usage
Unfortunately, there's no real way to keep your Gemini API key safe -- if you ship your Flutter app with the API key in there, someone can figure out how to dig it out. So, which this in mind, the model for initializing an instance of the Vertex AI LLM provider doesn't have an API key. Instead, it relies on a Firebase project, which requires that you initialize a Firebase project in your app. Preparing to do this requires a few steps:
1. Create a new project in [the Firebase Console](https://console.firebase.google.com/)
2. [Install the Firebase CLI](https://firebase.google.com/docs/cli). This will enable you to manager your Firebase projects from the CLI but more importantly, it's used by the FlutterFire CLI below.
3. Log into your Firebase account from the CLI via `firebase login`. This gives the FlutterFire CLI the credentials it needs to do its work for you.
4. Install [the FlutterFire CLI](https://firebase.google.com/docs/flutter/setup). You'll use this tool to generate the configuration code you need to initialize Firebase inside your Flutter app.
5. In your terminal, using `cd` to change to the `flutter_ai_toolkit/example` folder
6. Run `flutterfire config` to generate the `firebase_options.dart` file you need to include in any of the Firebase samples (just <a href="example/lib/vertex.dart">vertex.dart</a> today). Make sure to choose the project you created in step #1. If you're targeting Android and having changed the Android app ID, use "com.example.example".
7. To enable the Firebase ML API for use in your project, surf to https://console.cloud.google.com/apis/library/firebaseml.googleapis.com?project=YOUR-PROJECT-ID and press the Enable button. You can find your Firebase project's project ID in the `firebase_options.dart` file in any of the Dart data structions that contain a `projectId` field.
8. And finally, to enable the Vertex AI API, surf to https://console.developers.google.com/apis/api/aiplatform.googleapis.com/overview?project=YOUR-PROJECT-ID and click Enable. This one requires enabling billing, so be sure to be careful to set a quality and notifications while you're at it, too.

Once you've done all of that, you're ready to use Firebase Vertex AI in your project. Start by initializing Firebase:

```dart
// don't forget the pubspec.yaml entry, too
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
          provider: FirebaseVertexProvider(
            model: 'gemini-1.5-flash',
          ),
        ),
      );
}
```
If you like, use your Firebase project with the <a href="example/lib/vertex.dart">vertex.dart</a> sample. This sample has also been tested on Android, iOS, the web and macOS.

Note: There's no API key; Firebase manages all of that for you in the Firebase project. However, in the same way that someone can reverse engineer the Gemini API key out of your Flutter code, they can do that with your Firebase project ID and related settings. To guard against that, check out [Firebase AppCheck](https://firebase.google.com/learn/pathways/firebase-app-check), which is beyond the scope of the sample code in this project.

## More Features Coming Soon!
As I mentioned, the AI Toolkit is just in the alpha phase of it's lifetime and it's under active development. Coming soon, you should expect the following features:
- updated UX based on Google design guidelines
- theming and styling support
- stand-alone chatbot app sample with multi-session support
- structured LLM response data
- chat session serialization/deserialization
- app-provided prompt suggestions
- dev-configured chatbot label + icon
- chat microphone speech-to-tech prompt input
- pre-processing prompts to add prompt engineering, etc.
- pre-processing requests to enrich the output, e.g. host Flutter widgets
- thoroughly tested multi-platform support, including Windows and Linux
- support for Cupertino as well as Material

## Feedback!
Along the way, as you use this package, please [log issues and feature requests](https://github.com/csells/flutter_ai_toolkit/issues) as well as any [code you'd like to contribute](https://github.com/csells/flutter_ai_toolkit/pulls). I want your feedback and your contributions to ensure that the AI Toolkit is just as robust and useful as it can be for your real apps.
