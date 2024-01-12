# sovereign_chess

An online version of [Sovereign Chess](https://www.infinitepigames.com/sovereign-chess), built with Flutter.

Demo: https://sovereign-chess-demo.web.app/

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Development

```
# Start app for local development
flutter run --dart-define=WS_URI=wss://207.246.125.58/

# Then choose Chrome (2) as the target
```

## Deploy

We use Firebase hosting to serve the app. For first time setup instructions see [here](https://docs.flutter.dev/deployment/web#deploying-to-firebase-hosting).

The public directory is set to `~/build/web`.

```
# Build Flutter app
flutter build web --release --no-tree-shake-icons --dart-define=WS_URI=wss://207.246.125.58/

# Deploy to Firebase Hosting
firebase deploy
```

To test the build, you can run a web server locally. For example:
```
cd build/web
python -m http.server 8000
```
