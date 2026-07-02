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

// this is the main job feed screen for the job seekers
// displays a list of jobs that are scrollable
// users can save and unsave jobs, and tap on a job to see the details
class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {

  // service for all database operations (jobs, saved IDs, etc.)
  final DatabaseService _db = DatabaseService();

  // controller for the search text field. it's disposed in the dispose() method 
  final TextEditingController _searchController = TextEditingController();

  // this is the current search query entered by the user
  // anytime this changes, it triggers a UI rebuild (via setState)
  String _searchQuery = '';

  // getter to get the current user ID
  // if the user is not signed in, this will be null
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    // to clean up the search controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  // SEARCH / FILTER LOGIC
  // filters the list of jobs based on what's in the search bar
  // the search checks the job title, company name, and location
  // if the query is empty, it just lists all the jobs without filtering
  List<JobModel> _applySearch(List<JobModel> jobs) {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) return jobs;
    return jobs.where((job) {
      return job.title.toLowerCase().contains(query) ||
          job.company.toLowerCase().contains(query) ||
          job.location.toLowerCase().contains(query);
    }).toList();
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 1. search bar at the top
        _buildSearchBar(),

        // 2. expanded area for the job list (takes remaining height)
        Expanded(
          child: StreamBuilder<List<JobModel>>(
            // listen to real‑time updates from Firestore for all jobs
            stream: _db.getJobsStream(),
            builder: (context, jobsSnapshot) {
              // ERROR STATE
              if (jobsSnapshot.hasError) {
                return EmptyState(
                  icon: Icons.error_outline_rounded,
                  title: 'Couldn\'t load jobs',
                  subtitle: '${jobsSnapshot.error}',
                );
              }

              // LOADING STATE
              if (!jobsSnapshot.hasData) {
                return const LoadingIndicator();
              }

              // applying the search filter to the fetched job list
              final jobs = _applySearch(jobsSnapshot.data!);

              // EMPTY STATE where no jobs match the search query
              if (jobs.isEmpty) {
                return const EmptyState(
                  icon: Icons.search_off_rounded,
                  title: 'No jobs match your search',
                  subtitle: 'Try a different keyword.',
                );
              }

              // AUTHENTICATED USER FLOW 
              // if the user is NOT signed in, no need to show saved status
              if (_uid == null) {
                return _buildList(jobs, const {});
              }

              // SAVED JOBS
              // if the user IS signed in, saved jobs ID are fetched also
              // StreamBuilder updates the UI whenever the user saves/unsaves a job
              return StreamBuilder<Set<String>>(
                stream: _db.getSavedJobIdsStream(_uid!),
                builder: (context, savedSnapshot) {
                  // default to an empty set if data is not yet loaded
                  final savedIds = savedSnapshot.data ?? const {};
                  // build the job list with the correct saved status for each card
                  return _buildList(jobs, savedIds);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // BUILD JOB LIST
  // constructs the actual scrollable list of JobCard widgets
  // savedIds is a set of job IDs that the current user has saved for their profile
  Widget _buildList(List<JobModel> jobs, Set<String> savedIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // header showing the total number of jobs found
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            '${jobs.length} jobs found',
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: AppConfig.textMid),
          ),
        ),
        // the scrollable list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return JobCard(
                job: job,

                // determines whether the save icon appears filled or outlined
                isSaved: savedIds.contains(job.id),

                // tapping the card navigates to the detail screen
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => JobDetailScreen(job: job)),
                  );
                },
                // tapping the save icon toggles the saved state
                onSaveToggle: () => _toggleSave(job, savedIds.contains(job.id)),
              );
            },
          ),
        ),
      ],
    );
  }

  // SAVE / UNSAVE
  // this function toggles the saved status of a job for the current user
  // if the user is not signed in, they are required to sign in first
  Future<void> _toggleSave(JobModel job, bool isCurrentlySaved) async {
    final uid = _uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to save jobs')),
      );
      return;
    }
    // if currently saved, unsave it, otherwise, save it
    if (isCurrentlySaved) {
      await _db.unsaveJob(uid, job.id);
    } else {
      await _db.saveJob(uid, job.id);
    }
  }

  // SEARCH BAR UI
  // onChanged callback updates _searchQuery and triggers a rebuild via `setState`, which re‑filters the job list
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
