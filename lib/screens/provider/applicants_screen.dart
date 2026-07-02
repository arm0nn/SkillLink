// lib/screens/provider/applicants_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/application_model.dart';
import '../../models/job_model.dart';
import '../../services/database_service.dart';
import '../../widgets/applicant_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/loading_indicator.dart';

class ApplicantsScreen extends StatelessWidget {
  final JobModel job;

  const ApplicantsScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();

    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppConfig.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(job.title,
            style: const TextStyle(
                color: AppConfig.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: db.getApplicantsForJobStream(job.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return EmptyState(
              icon: Icons.error_outline_rounded,
              title: 'Couldn\'t load applicants',
              subtitle: '${snapshot.error}',
            );
          }
          if (!snapshot.hasData) {
            return const LoadingIndicator();
          }

          final applicants = snapshot.data!
            ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));

          if (applicants.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline_rounded,
              title: 'No applicants yet',
              subtitle: 'Check back once people start applying.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applicants.length,
            itemBuilder: (context, index) {
              final applicant = applicants[index];
              return ApplicantCard(
                application: applicant,
                onStatusChange: (newStatus) {
                  db.updateApplicationStatus(applicant.id, newStatus);
                },
              );
            },
          );
        },
      ),
    );
  }
}
