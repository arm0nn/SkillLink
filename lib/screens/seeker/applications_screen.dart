// lib/screens/seeker/applications_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/application_model.dart';
import '../../services/database_service.dart';
import '../../widgets/application_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';

// displays all the applications that have been made by the user
// list updates in real time based on application changes
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // get the current user ID. If there's no user ID, the user is not authenticated
    final uid = FirebaseAuth.instance.currentUser?.uid;

    // UNAUTHENTICATED STATE  
    // If the user is not signed in, show a lock icon and message asking them to sign in
    if (uid == null) {
      return const EmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Sign in to see your applications',
        subtitle: 'Track every job you\'ve applied to in one place.',
      );
    }

    // database service to fetch applications
    final db = DatabaseService();

    // AUTHENTICATED USER STATE
    // StreamBuilder listens to updates in real time for user applications
    return StreamBuilder<List<ApplicationModel>>(
      stream: db.getApplicationsBySeekerStream(uid),
      builder: (context, snapshot) {

        // ERROR STATE
        // if there's an error in the stream, display an error message
        if (snapshot.hasError) {
          return EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Couldn\'t load applications',
            subtitle: '${snapshot.error}',
          );
        }

        // LOADING STATE
        // while the data is being fetched, loading indicator is shown
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }

        // DATA RECEIVED
        // sorting the applications by the most recent applications first
        final applications = snapshot.data!
          ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

        // NO APPLICATIONS
        // if list is empty, show empty state
        if (applications.isEmpty) {
          return const EmptyState(
            icon: Icons.description_outlined,
            title: 'No applications yet',
            subtitle: 'Jobs you apply to will show up here.',
          );
        }

        // POPULATED LIST
        // scrollable list of application widgets, each having their own respective details
        // each receiving the application data.
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: applications.length,
          itemBuilder: (context, index) =>
              ApplicationCard(application: applications[index]),
        );
      },
    );
  }
}
