// lib/screens/seeker/job_feed_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../services/database_service.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/job_card.dart';
import '../../widgets/loading_indicator.dart';
import 'job_detail_screen.dart';

class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  final DatabaseService _db = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<JobModel> _applySearch(List<JobModel> jobs) {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) return jobs;
    return jobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: StreamBuilder<List<JobModel>>(
            stream: _db.getJobsStream(),
            builder: (context, jobsSnapshot) {
              if (jobsSnapshot.hasError) {
                return EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Couldn\'t load jobs',
                  subtitle: '${jobsSnapshot.error}',
                );
              }
              if (!jobsSnapshot.hasData) {
                return const LoadingIndicator();
              }

              final jobs = _applySearch(jobsSnapshot.data!);

              if (jobs.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No jobs match your search',
                  subtitle: 'Try a different keyword.',
                );
              }

              if (_uid == null) {
                return _buildList(jobs, const {});
              }

              return StreamBuilder<Set<String>>(
                stream: _db.getSavedJobIdsStream(_uid!),
                builder: (context, savedSnapshot) {
                  final savedIds = savedSnapshot.data ?? const {};
                  return _buildList(jobs, savedIds);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<JobModel> jobs, Set<String> savedIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            '${jobs.length} jobs found',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppConfig.textMid),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(
                job: job,
                isSaved: savedIds.contains(job.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => JobDetailScreen(job: job)),
                  );
                },
                onSaveToggle: () => _toggleSave(job, savedIds.contains(job.id)),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _toggleSave(JobModel job, bool isCurrentlySaved) async {
    final uid = _uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to save jobs')),
      );
      return;
    }
    if (isCurrentlySaved) {
      await _db.unsaveJob(uid, job.id);
    } else {
      await _db.saveJob(uid, job.id);
    }
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppConfig.chipBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'Job title, company, location…',
            hintStyle: TextStyle(color: AppConfig.textFaint, fontSize: 14),
            prefixIcon:
                Icon(Icons.search_rounded, color: AppConfig.textFaint, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13),
          ),
        ),
      ),
    );
  }
}
