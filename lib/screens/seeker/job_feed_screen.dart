import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../providers/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/job_card.dart';
import 'job_detail_screen.dart';

class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});
  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JobModel> _filtered(List<JobModel> jobs) {
    final query = _query.toLowerCase();
    return jobs
        .where((job) =>
            query.isEmpty ||
            job.title.toLowerCase().contains(query) ||
            job.company.toLowerCase().contains(query) ||
            job.location.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                  hintText: 'Job title, company, location…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: AppConfig.chipBg,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none)),
            )),
        Expanded(child: Consumer<AppState>(builder: (context, state, _) {
          final jobs = _filtered(state.jobs);
          if (jobs.isEmpty)
            return const EmptyState(
                icon: Icons.search_off_rounded,
                title: 'No jobs match your search',
                subtitle: 'Try a different keyword.');
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: jobs.length,
            itemBuilder: (_, index) {
              final job = jobs[index];
              return JobCard(
                  job: job,
                  isSaved: state.savedJobIds.contains(job.id),
                  onSaveToggle: () => state.toggleSavedJob(job.id),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JobDetailScreen(job: job))));
            },
          );
        }))
      ]);
}
