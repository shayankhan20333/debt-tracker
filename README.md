# Depth Tracker

Depth Tracker is a Flutter app to manage personal debts and receivables. Track who owes you, what you owe others, monitor outstanding vs settled items, and keep everything in sync with Firebase while caching locally with Isar for offline-friendly usage.

## Features
- Authentication (Email/Password and Google Sign-In if configured)
- Receivables and Loans with All / Outstanding / Settled views
- Detail actions: Pay / Receive, creator-only delete, and debtor removal per record
- Local caching with Isar for fast access and offline support
- Real-time Cloud Firestore sync plus refresh reconcile to avoid duplicates
- Profile screen with user info

## Tech Stack
- Flutter
- Firebase Auth, Cloud Firestore
- Isar local database
- Provider for state management

## Folder Structure (high level)
- `lib/screens` – UI screens (home, receivables, loans, auth, profile, detail views)
- `lib/providers` – state management for receivables/users
- `lib/services` – Firebase/Isar access, auth, user, receivable logic
- `lib/model` – data models
- `lib/DataBase/isar` – Isar collections and helpers
- `assets` – images and other static assets

## Setup
1) Prerequisites:
   - Flutter SDK
   - Android SDK / Xcode as appropriate
   - Firebase project (optional Firebase CLI for setup)

2) Install dependencies:
```bash
flutter pub get
```

3) Firebase config:
   - Add your Firebase config files (not committed):
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - If using FlutterFire CLI, ensure generated `firebase_options.dart` is present or regenerate as needed.

4) Run the app:
```bash
flutter run
```

## Environment / Secrets
- Firebase config files are excluded from git. Place them in the platform folders above.
- If your setup uses additional env files, keep them out of version control and document placeholders accordingly (e.g., `.env.example`).

## Build Release APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

## Troubleshooting
- Google Sign-In ApiException 10 / DEVELOPER_ERROR: ensure SHA-1/SHA-256 are added in Firebase for your appId and download an updated `google-services.json`.
- Firestore permissions/rules: confirm rules allow the operations you need.
- Isar codegen issues: run
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Contributing
- Fork, create a branch, open a PR with clear description.

## License
- MIT (or your chosen license)
