// lib/screens/seeker/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/app_config.dart';
import '../../models/job_model.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_button.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final DatabaseService _db = DatabaseService();
  bool _isApplying = false;
  bool _hasApplied = false;

  Future<void> _handleApply() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to apply for jobs')),
      );
      return;
    }

    setState(() => _isApplying = true);
    try {
      await _db.applyToJob(
        jobId: widget.job.id,
        jobTitle: widget.job.title,
        company: widget.job.company,
        seekerId: uid,
      );
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
      if (mounted) {
        setState(() => _isApplying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to apply: $e')),
        );
      }
    }
  }

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
                  Text(job.title,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppConfig.textDark)),
                  const SizedBox(height: 6),
                  Text(job.company,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppConfig.textMuted)),
                  const SizedBox(height: 16),
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
