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

## Installation

- Install Flutter
- Install Firebase (see Deploy section)

## Development

```
# Start app for local development
./bin/run.sh

# Press 'r' in the terminal process to hot reload changes to code.
```

## Deploy

We use Firebase hosting to serve the app. For first time setup instructions see [here](https://docs.flutter.dev/deployment/web#deploying-to-firebase-hosting).

The public directory is set to `~/build/web`.

```
# Build Flutter app
./bin/build.sh

# Deploy to Firebase Hosting
firebase deploy
```

To test the build, you can run a web server locally. For example:
```
cd build/web
python -m http.server 8000
```
