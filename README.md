# SkillLink
---
## Group Members
**Group Name:** Barca
| Name | Matric No | Assigned Tasks |
| ---- | --------- | ------------- |
| Arman Irfan Bin 'Azim | 2216101 | Job Seeker Pages, Profile Page, Edit Profile Page. **CODES:** `applications_screen.dart`, `job_detail_screen.dart`, `job_feed_screen.dart`, `seeker_dashboard.dart`, `profile_screen.dart`, `edit_profile_screen.dart`|
| Aminul Shahir Bin Mohd Aminuddin | 2228907 | Landing Page + Register & Log in Page + Authentication. **CODES:** `lib/screens/auth/splash_screen.dart`, `landing_screen.dart`, `login_screen.dart`, `register_screen.dart`, `providers/auth_provider.dart`, `services/auth_service.dart`, `widgets/custom_button.dart`, `custom_textfield.dart` `config/app_config.dart`, `utils/validators.dart` |
| Amir Fauzi Bin Ne'mat | 2220659 | Job Posting Page + Firebase Integration. **CODES:** `lib/screens/provider/post_job_screen.dart`, `my_jobs_screen.dart, applicants_screen.dart`, `services/database_service.dart`, `services/auth_service.dart`, `firebase_options.dart, models (job_model.dart, application_model.dart)` |
| Ali Ilhan Thani Bin Jalaludin | 2222253 | Job Provider Pages. Profile Page, Edit Profile Page. **CODES:** `applicants_screen.dart`, `my_jobs_screen.dart`, `post_job_screen.dart`, `provider_dashboard.dart`|

---

## 1. Project Ideation and Initiation

**Title :** SkillLink

**Background of the Problem :** 
A combination of study and looking for part-time work is not without its responsibilities. Students may have to manage their limited free time with the pressures of the job search. This is particularly true if you are applying for more than one part-time job that has varying schedules and requirements. Students often overlook deadlines, interview schedules, and confirmations of shifts and more, only to discover the missed deadline later when the information has been forgotten or is buried in a jumble of notes on various platforms at different locations. Another common problem is that they don't have tools to monitor application progress or employer's response, which could enable students to keep track of their job search effectively while they're enrolled in school.

**The objectives of the App are :**
- Centralize job application management, interview schedules and employer communications.
- Help students stay on top of deadlines and follow-ups through reminders.
- Facilitate monitoring of application progress to determine progress and next steps at a point of real-time.
- Assist employers to post part-time positions easily, manage applicants and communicate updates to applicants.

**Target Users :** Students looking for part-time work opportunities and employers looking for part-time employees.

**Preferred Platform :** Mobile application. Developed using Dart and Flutter.

**Features and Functionality :** 
- **Profile :** Both job seekers and job providers have profile pages. Both types of pages show the name and email.
- **Dashboard :** For the job seekers, it shows the current available jobs on the market, and also shows pending applications made by the seekers. For the job providers, it shows the list of jobs that they have posted and shows the users that have applied to their jobs.

---

## 2. Requirement Analysis and Planning
## CRUD Operation Analysis
**Job Provider:**

1. Create account. (job seeker)
2. Read the posted jobs.
3. Update the name of the user. (job seeker)

**Job Providers:**

1. Create account. (job provider)
2. Create jobs - post jobs. (including location specification)
3. Read - Keep track of posted jobs.
4. Read - Keep track of applicants for each posted jobs.
5. Update applicant's status. (reviewed, rejected, succesful)
6. Update - Customize profile name.

---

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

---

## Firestore collections this app expects

- `jobs/{jobId}` — fields: `title`, `company`, `location`, `status`
- `users/{uid}` — fields: `name`, `email`, `photoUrl`, `resumeUrl`
  (uid matches the FirebaseAuth user's uid)
- `users/{uid}/savedJobs/{jobId}` — bookmark subcollection
- `applications/{applicationId}` — fields: `jobId`, `jobTitle`, `company`,
  `seekerId`, `status`, `appliedAt`

---
## 3. Project Design
## Screen Navigation Flow Diagram

<p align="center">
  <a href="diagrams/Screen Flow Diagram.png">
    <img src="diagrams/Screen Flow Diagram.png" alt="Diagram" width="600">
  </a>
</p>

## Gantt Chart

<p align="center">
  <a href="diagrams/Skillink Ganttchart.png">
    <img src="diagrams/Skillink Ganttchart.png" alt="Diagram" width="600">
  </a>
</p>

---

## References
- Add data to Cloud Firestore. (n.d.). Firebase. Retrieved February 2, 2026, from https://firebase.google.com/docs/firestore/manage-data/add-data

- BottomNavigationBar class—Material library—Dart API. (n.d.). Retrieved February 2, 2026, from https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html

- Navigation and routing. (n.d.). Retrieved February 2, 2026, from https://docs.flutter.dev/ui/ui/navigation/index.md

- Wrap class—Widgets library—Dart API. (n.d.). Retrieved February 2, 2026, from https://api.flutter.dev/flutter/widgets/Wrap-class.html
