# SkillLink

A Flutter job listings app for the Malaysian market, backed by Firebase
(Auth + Firestore).

## Update 1: two bugs fixed

**1. Login succeeded but the screen never changed.**
Root cause: `LoginScreen`/`RegisterScreen` were being pushed with
`Navigator.push`, which took them outside the `Consumer<AppAuthProvider>`
in `SplashScreen` that's supposed to react to auth state and switch
screens. Fix: `SplashScreen` is now the permanent root — it owns
showing Login vs. Register vs. the right Dashboard at all times, and
swaps between them via a local `_showRegister` flag instead of pushing
routes. `LoginScreen`/`RegisterScreen` now take `onSwitchToLogin` /
`onSwitchToRegister` callbacks instead of using `Navigator.pop`/`push`
for the "switch between login and register" links.

**2. No way to register as a provider.**
`role_selection_screen.dart` existed but was never wired in, and
`UserModel`/registration never asked for or stored a role at all. Fix:
added a `role` field to `UserModel` (defaults to `'seeker'`), a
Seeker/Provider toggle directly on the register form, and
`SplashScreen` now branches to `SeekerDashboard` or `ProviderDashboard`
based on `userProfile.role` after login. `role_selection_screen.dart`
is unused now — kept in the project in case you want a "switch roles"
feature later, but not part of the active flow.

**If you already have test accounts from before this fix**, they won't
have a `role` field in Firestore — they'll default to `'seeker'`. Either
add `role: "provider"` to the doc manually in the Firebase console for
any provider test accounts, or just re-register.

## Update 2: routing still broken after Update 1, plus drawer didn't navigate

**Symptom:** after the Update 1 fix, login/register still didn't route
to the dashboard — you had to tap the "switch to register/login" text
link to get moved, and `ProfileScreen` showed "sign in to view your
profile" even though Firebase Auth + Firestore both had the account.

**Root cause:** `AppAuthProvider` only updated its state via Firebase's
`authStateChanges` stream listener. `login()`/`register()` awaited the
Firebase call itself succeeding, but did NOT wait for that separate
stream listener to actually fire and finish its own async Firestore
profile fetch — so `isLoggedIn`/`userProfile` could still read as
"not logged in" for a beat after login genuinely succeeded. Tapping the
register/login toggle just happened to trigger an unrelated rebuild
that coincided with the stream catching up, which is why it looked like
that tap was "the fix."

**Fix:** added `AppAuthProvider.refreshAuthState()`, which explicitly
re-reads `FirebaseAuth.instance.currentUser` and the Firestore profile
synchronously, and `login()`/`register()`/`logout()` now call it
directly after their Firebase call completes — instead of relying
solely on the stream listener to eventually catch up.

**Also fixed:** the hamburger drawer's menu items (Job Listings, My
Applications, Profile) didn't do anything — they only closed the
drawer. `AppDrawer` is now built from a list of `DrawerMenuItem`s that
each dashboard defines itself with real `onTap` callbacks that switch
tabs, instead of a fixed set of `Navigator.pop`-only `ListTile`s. The
provider dashboard's drawer now shows its own correct items (My Jobs,
Post a Job, Profile) instead of seeker-only labels that didn't apply to
it.

## Status: this is a working scaffold, not a finished app

Everything compiles and the seeker-side flow (register → log in → browse
jobs → save → apply → see applications) works end-to-end once Firebase is
connected. Provider-side (register as provider → post job → see
applicants → change their status) also works now. A few pieces are
still intentionally thin — see "What's scaffolded vs. real" below.

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

## What's scaffolded vs. real — talk through these as a team

**job_model.dart** — kept to your original 4 fields (title, company,
location, status) plus an added `id`. No salary, type, or tags. If the
team wants those, extend the model and the matching forms/cards.

**`status` on JobModel vs. ApplicationModel** — right now `status`
lives on the job itself ('pending'/'successful'), and a *separate*
`ApplicationModel.status` tracks a seeker's individual application
progress ('pending'/'reviewed'/'successful'/'rejected'). These are
two different things wearing the same word. Worth a team conversation:
does job.status mean something else (e.g. listing approved/live), or
should it be removed in favor of ApplicationModel.status entirely?

**role_selection_screen.dart** — built but unused. Role is now chosen
via a toggle on the register form itself (see Update section above)
rather than a separate screen after registration.

**Photo / resume upload** — `edit_profile_screen.dart` only edits the
name field. Wiring up `photoUrl`/`resumeUrl` needs Firebase Storage
(pick a file → upload → save the download URL) — not implemented.

**applicant_card.dart** — shows a truncated seekerId instead of the
applicant's actual name/email, since `ApplicationModel` only stores the
uid. Either fetch the matching `UserModel` per card, or denormalize
name/email onto `ApplicationModel` when the application is created —
team's call.

**Firestore security rules** — not included. Test-mode rules allow
anyone to read/write everything; you'll want real rules before this
goes anywhere near production (e.g. only the application's owner or the
job's provider can read/update an application).

**Provider role flows are minimal** — `post_job_screen.dart` only
collects what JobModel currently supports. `applicants_screen.dart`
lets a provider change an applicant's status via dropdown but has no
applicant detail view.

## Project structure

Matches the structure your team agreed on — see folder layout in
`lib/`. Each screen/service/model file has inline `NOTE for team:`
comments wherever a decision was made that you should sanity-check
rather than just inherit silently.
