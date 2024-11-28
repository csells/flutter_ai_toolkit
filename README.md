Hello and welcome to the Flutter AI Toolkit!

The AI Toolkit is a set of AI chat-related widgets to make it easy to add an AI chat window to your Flutter app. The AI Toolkit is organized around an abstract LLM provider API to make it easy to swap out the LLM provider that you'd like your chat provider to use. Out of the box, it comes with support for two LLM provider integrations: Google Gemini AI and Firebase Vertex AI.

## Features
- multi-turn chat (remembering context along the way)
- streaming responses
- multi-line chat text input
- cancel in-progress request
- edit the last prompt
- rich text response display
- chat microphone speech-to-tech prompt input
- copy any response
- multi-media attachments
- handling structured LLM responses to show app-specific Flutter widgets
- app-provided prompt suggestions
- pre-processing prompts to add logging, prompt engineering, etc.
- custom styling support
- support for Cupertino as well as Material
- chat session serialization/deserialization
- swappable support for LLM providers; oob support for Gemini and Vertex
- support for the same Flutter platforms that Firebase supports: Android, iOS, web and macOS

Here's [the online demo](https://flutter-ai-toolkit-examp-60bad.web.app/) hosting the AI Tookit:

<img src="https://raw.githubusercontent.com/csells/flutter_ai_toolkit/main/README/screenshot.png" height="800"/>

The [source code for this demo](https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/demo/demo.dart) is available in the repo.

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
1. a model created using a model string, which you can ready about in [the Gemini models docs](https://ai.google.dev/gemini-api/docs/models/gemini), and 
2. an API key, which you can get [in Gemini AI Studio](https://aistudio.google.com/app/apikey).

With this in place, you're ready to write the Gemini code shown above. If you like, you can plug your API key and model string into the <a href="https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/gemini/gemini.dart">gemini.dart</a> sample. This sample has been tested on Android, iOS, the web and macOS, so give it a whirl.
### gemini_api_key.dart
Most of [the sample apps](https://github.com/csells/flutter_ai_toolkit/tree/main/example) reply on a Gemini API key, so for those to work, you'll need to plug your API key into a file called `gemini_api_key.dart` and put it in the `example/lib` folder (after cloning the repo, of course). Here's what it should look like:

```dart
// example/lib/gemini_api_key.dart
const geminiApiKey = 'YOUR-API-KEY';
```

Note: Be careful not to check your API key into a git repo or share it with anyone.
## Vertex LLM Usage
While Gemini AI is useful for quick prototyping, the recommended solution for production apps is Vertex AI in Firebase. And the reason for that is that there's no good way to keep your Gemini API key safe -- if you ship your Flutter app with the API key in there, someone can figure out how to dig it out.

To solve this problem as well as many others that you're going to have in a real-world production app, the model for initializing an instance of the Vertex AI LLM provider doesn't have an API key. Instead, it relies on a Firebase project, which you then initialize in your app. You can do that with the steps described in [the Get started with the Gemini API using the Vertex AI in Firebase SDKs docs](https://firebase.google.com/docs/vertex-ai/get-started?platform=flutter).

Also make sure you configure your FlutterApp using the `flutterfire` CLI tool as described in [the Add Firebase to your Flutter app docs](https://firebase.google.com/docs/flutter/setup).

After following these instructions, you're ready to use Firebase Vertex AI in your project. Start by initializing Firebase:

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

This is the same way that you'd initialize Firebase for use in any Flutter project, so it should be familiar to existing FlutterFire users.

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
If you like, use your Firebase project with the <a href="https://github.com/csells/flutter_ai_toolkit/blob/main/example/lib/vertex/vertex.dart">vertex.dart</a> sample. This sample is supported on Android, iOS, the web and macOS.

Note: There's no API key; Firebase manages all of that for you in the Firebase project. However, in the same way that someone can reverse engineer the Gemini API key out of your Flutter code, they can do that with your Firebase project ID and related settings. To guard against that, check out [Firebase AppCheck](https://firebase.google.com/learn/pathways/firebase-app-check).

## Device Access Permissions
To enable the microphone feature, configure your app according to [the record package's permission setup instructions](https://pub.dev/packages/record#setup-permissions-and-others).

To enable the user to select a file on their device to upload to the LLM, configure your app according to [the file_selector plugin's usage instructions](https://pub.dev/packages/file_selector#usage).

To enable the user to select an image file on their device, configure your app according to [the image_picker plugin's installation instructions](https://pub.dev/packages/image_picker#installation).

To enable the user to take a picture on their device, configurate your app according to [the image_picker plugin's installation instructions](https://pub.dev/packages/image_picker#installation).

To enable the user to take a picture on the web, configure your app according to [the camera plugin's setup instructions](https://pub.dev/packages/camera#setup).

## Feedback!
Along the way, as you use this package, please [log issues and feature requests](https://github.com/csells/flutter_ai_toolkit/issues) as well as any [code you'd like to contribute](https://github.com/csells/flutter_ai_toolkit/pulls). I want your feedback and your contributions to ensure that the AI Toolkit is just as robust and useful as it can be for your real-world apps.
