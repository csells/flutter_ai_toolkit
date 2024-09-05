<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.

## Examples
### Gemini
Get an API key

### Firebase Vertex
- make sure that the firebase CLI is installed on your machine
- log into your firebase account: firebase login
- make sure that the flutterfire CLI is installed on your machine (link)
- cd into the example fold
- flutterfire config (link)
  - if you have trouble creating a new project, I recommend using console.firebase.google.com to create a project and letting flutterfire config create the apps
- you should now have a firebase_options.dart file
- enable the Firebase ML API (link: https://console.cloud.google.com/apis/library/firebaseml.googleapis.com?project=YOUR-PROJECT-ID)
  - where do I get my project ID?
    - look for projectId in firebase_options.dart
- enable the Vertex AI API (link: https://console.developers.google.com/apis/api/aiplatform.googleapis.com/overview?project=YOUR-PROJECT-ID)
  - this requires enabling billing (link: firebase vertex API billing)
