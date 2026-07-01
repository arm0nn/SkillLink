// lib/screens/provider/my_jobs_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../services/database_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';
import 'applicants_screen.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const EmptyState(
        icon: Icons.lock_outline_rounded,
        title: 'Sign in to manage your jobs',
        subtitle: 'Post listings and review applicants.',
      );
    }

    final db = DatabaseService();

    return StreamBuilder<List<JobModel>>(
      stream: db.getJobsByProviderStream(uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Couldn\'t load your jobs',
            subtitle: '${snapshot.error}',
          );
        }
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }

        final jobs = snapshot.data!;

        if (jobs.isEmpty) {
          return const EmptyState(
            icon: Icons.business_center_outlined,
            title: 'No jobs posted yet',
            subtitle: 'Tap "Post Job" to create your first listing.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppConfig.cardBorder),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(job.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppConfig.textDark)),
                subtitle: Text('${job.company} · ${job.location}',
                    style: const TextStyle(
                        fontSize: 12.5, color: AppConfig.textMuted)),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppConfig.textFaint),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ApplicantsScreen(job: job)),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
