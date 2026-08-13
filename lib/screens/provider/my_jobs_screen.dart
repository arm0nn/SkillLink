import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../widgets/empty_state.dart';
import 'applicants_screen.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      Consumer<AppState>(builder: (context, state, _) {
        final uid = state.userProfile?.uid;
        final jobs = state.jobs.where((job) => job.providerId == uid).toList();
        if (jobs.isEmpty)
          return const EmptyState(
              icon: Icons.business_center_outlined,
              title: 'No jobs posted yet',
              subtitle: 'Tap "Post Job" to create your first listing.');
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
          itemCount: jobs.length,
          itemBuilder: (_, index) {
            final job = jobs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppConfig.cardBorder)),
              child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(job.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppConfig.textDark)),
                  subtitle: Text('${job.company} · ${job.location}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ApplicantsScreen(job: job)))),
            );
          },
        );
      });
}
