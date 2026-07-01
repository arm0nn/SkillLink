# SkillLink

A Flutter job listings app for the Malaysian market, backed by Firebase
(Auth + Firestore).

## Setup

1. **Create a Firebase project** at console.firebase.google.com.
2. **Install the CLIs**:
   ```bash
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   ```
3. **From this project's root, run**:
   ```bash
   flutterfire configure
   ```
   This overwrites `lib/firebase_options.dart` (currently a placeholder)
   with your real project config.
4. **Get packages**:
   ```bash
   flutter pub get
   ```
5. **In the Firebase Console**, enable:
   - Authentication → Sign-in method → Email/Password
   - Firestore Database → Create database (start in test mode while
     developing, lock down rules before shipping)
6. **Run it**:
   ```bash
   flutter run
   ```

## Firestore collections this app expects

- `jobs/{jobId}` — fields: `title`, `company`, `location`, `status`
- `users/{uid}` — fields: `name`, `email`, `photoUrl`, `resumeUrl`
  (uid matches the FirebaseAuth user's uid)
- `users/{uid}/savedJobs/{jobId}` — bookmark subcollection
- `applications/{applicationId}` — fields: `jobId`, `jobTitle`, `company`,
  `seekerId`, `status`, `appliedAt`
