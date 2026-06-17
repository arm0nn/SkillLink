// lib/screens/applied_jobs_screen.dart
import 'package:flutter/material.dart';
import '../models/job_model.dart';

class AppliedJobsScreen extends StatelessWidget {
  const AppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    List<JobModel> jobs = [
      JobModel(
        title: 'Software Developer',
        company: 'Google',
        location: 'KL',
        status: 'pending',
      ),
      JobModel(
        title: 'UI/UX Designer',
        company: 'AirAsia',
        location: 'PJ',
        status: 'successful',
      ),
      JobModel(
        title: 'Data Analyst',
        company: 'Maybank',
        location: 'KL',
        status: 'pending',
      ),
      JobModel(
        title: 'Mobile Developer',
        company: 'Grab',
        location: 'SG',
        status: 'successful',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Applied Jobs')),
      body: jobs.isEmpty
          ? const Center(child: Text('No applications'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.company),
                  trailing: Text(job.status),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(job.title),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Company: ${job.company}'),
                            Text('Location: ${job.location}'),
                            Text('Status: ${job.status}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}