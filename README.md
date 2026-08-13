# SkillLink

SkillLink is a Flutter UI/UX prototype for a Malaysian student job marketplace.

## Current scope

This project is intentionally frontend-only. Authentication, job listings,
applications, bookmarks, applicant statuses, and profile edits are simulated
with in-memory demo state in `lib/providers/app_state.dart`. No data is sent to
a server or persisted; restarting the app restores the initial demo content.

## Run locally

```bash
flutter pub get
flutter run
```

## Product direction

- Job seekers can explore and save jobs, submit demo applications, and edit a profile.
- Job providers can post demo jobs and review demo applicants.
- The current phase is focused on navigation, visual design, interaction flows, and usability.

Backend architecture and persistence can be designed after the UI/UX direction is settled.
