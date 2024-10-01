cd example
rm -rf build/web
flutter build web --release --target lib/demo/demo.dart
firebase deploy
cd ..
