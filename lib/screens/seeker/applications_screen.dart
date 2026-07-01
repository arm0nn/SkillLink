// lib/screens/seeker/applications_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/application_model.dart';
import '../../services/database_service.dart';
import '../../widgets/application_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const EmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Sign in to see your applications',
        subtitle: 'Track every job you\'ve applied to in one place.',
      );
    }

    final db = DatabaseService();

    return StreamBuilder<List<ApplicationModel>>(
      stream: db.getApplicationsBySeekerStream(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Couldn\'t load applications',
            subtitle: '${snapshot.error}',
          );
        }
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }

        final applications = snapshot.data!
          ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

        if (applications.isEmpty) {
          return const EmptyState(
            icon: Icons.description_outlined,
            title: 'No applications yet',
            subtitle: 'Jobs you apply to will show up here.',
          );
        }

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
