// lib/models/job_model.dart
class JobModel {
  final String title;
  final String company;
  final String location;
  final String status; // 'pending' or 'successful'

  JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.status,
  });
}