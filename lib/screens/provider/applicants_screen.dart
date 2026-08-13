import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/application_model.dart';
import '../../models/job_model.dart';
import '../../providers/app_state.dart';
import '../../widgets/applicant_card.dart';
import '../../widgets/empty_state.dart';

class ApplicantsScreen extends StatelessWidget {
  final JobModel job;
  const ApplicantsScreen({super.key, required this.job});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppConfig.background,
        appBar: AppBar(title: Text(job.title)),
        body: Consumer<AppState>(builder: (context, state, _) {
          final items = List<ApplicationModel>.of(
              state.applications.where((item) => item.jobId == job.id))
            ..sort((a, b) => b.appliedAt.compareTo(a.appliedAt));
          if (items.isEmpty)
            return const EmptyState(
                icon: Icons.people_outline_rounded,
                title: 'No applicants yet',
                subtitle: 'Check back once people start applying.');
          return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (_, index) {
                final item = items[index];
                return ApplicantCard(
                    application: item,
                    onStatusChange: (status) =>
                        state.updateApplicationStatus(item.id, status));
              });
        }),
      );
}
