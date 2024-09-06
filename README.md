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

<img src="README/screenshot.png" height="800"/>

## Getting started

To use the AI Toolkit is just a matter of choosing which LLM provider you'd like to use (Gemini or Vertex), creating an instance and passing it to the `LlmChatView` widget, which is the main entry point for the AI Toolkit:

```dart
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

... // app stuff here

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: LlmChatView(
          provider: GeminiProvider(
            model: 'gemini-1.5-flash',
            apiKey: googleApiKey,
          ),
        ),
      );
}
```

Here we're creating an instance of the `GeminiProvider`, configuring it as appropriate and passing it to an instance of the `LlmChatView`. That's really all you can do at this point (there are more features coming -- see below). That yields the screenshot above using Google Gemini AI as the LLM. You can see more details about configuring both the Gemini and Vertex LLM providers below.

## Gemini LLM Usage
TODO: Get an API key
TODO: gemini sample

## Vertex LLM Usage
TODO: don't put API keys in your client apps!
- make sure that the firebase CLI is installed on your machine
- log into your firebase account: firebase login
- make sure that the flutterfire CLI is installed on your machine (link)
- cd into the example fold
- flutterfire config (link:https://firebase.google.com/docs/flutter/setup)

  - if you have trouble creating a new project, I recommend using console.firebase.google.com to create a project and letting flutterfire config create the apps
- you should now have a firebase_options.dart file
- enable the Firebase ML API (link: https://console.cloud.google.com/apis/library/firebaseml.googleapis.com?project=YOUR-PROJECT-ID)
  - where do I get my project ID?
    - look for projectId in firebase_options.dart
- enable the Vertex AI API (link: https://console.developers.google.com/apis/api/aiplatform.googleapis.com/overview?project=YOUR-PROJECT-ID)
  - this requires enabling billing (link: firebase vertex API billing)
TODO: vertex sample

## Demo
TODO: one more sample -- hosted at TODO:link for your enjoyment

## Features Coming Soon!
TODO

## Additional information
TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
