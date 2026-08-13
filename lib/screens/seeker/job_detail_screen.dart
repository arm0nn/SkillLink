// lib/screens/seeker/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../providers/app_state.dart';
import '../../widgets/custom_button.dart';

// displays the full details of a single job and allows the user to apply
// the job data is obtained from the constructor
class JobDetailScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  // service for database operations when applying for a job
  // to show a loading spinner on the apply button while the request is in progress
  bool _isApplying = false;

  // to indicate whether the user has already applied to this job
  // if it's true, the apply button becomes disabled and shows "Applied ✓"
  bool _hasApplied = false;

  // APPLY LOGIC
  // handles the job application process.
  // checks for if the user is signed in, then calls the database service to create an application
  Future<void> _handleApply() async {
    // 1. ensures the user is signed in
    // 2. shows the loading state (disable button, show spinner)
    setState(() => _isApplying = true);

    try {
      // 3. call the database service to create the application document
      context.read<AppState>().applyToJob(widget.job);

      // 4. once successful, update the UI and show a confirmation message
      if (mounted) {
        setState(() {
          _hasApplied = true;
          _isApplying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted!')),
        );
      }
    } catch (e) {
      // 5. if unsuccessful, hide the loading state and show an error message
      if (mounted) {
        setState(() => _isApplying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply: $e')),
        );
      }
    }
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    final job = widget.job;

    return Scaffold(
      backgroundColor: AppConfig.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppConfig.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Job Details',
            style: TextStyle(
                color: AppConfig.textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // JOB DETAILS CARD
            // white card with displaying the job's title, company, location, and status.
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppConfig.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // job Title (large, bold)
                  Text(job.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppConfig.textDark)),
                  const SizedBox(height: 6),
                  // company Name (medium, muted)
                  Text(job.company,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.textMuted)),
                  const SizedBox(height: 16),
                  // location row
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppConfig.textFaint),
                      const SizedBox(width: 6),
                      Text(job.location,
                          style: const TextStyle(
                              fontSize: 13, color: AppConfig.textMuted)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // status row ("open", "closed")
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 16, color: AppConfig.textFaint),
                      const SizedBox(width: 6),
                      Text('Status: ${job.status}',
                          style: const TextStyle(
                              fontSize: 13, color: AppConfig.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // APPLY BUTTON
            // CustomButton that changes label if the user has applied or has not applied, and shows loading spinner during application process
            CustomButton(
              label: _hasApplied ? 'Applied ✓' : 'Apply Now',
              onPressed: _hasApplied ? null : _handleApply,
              isLoading: _isApplying,
            ),
          ],
        ),
      ),
    );
  }
}
