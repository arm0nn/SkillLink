// lib/models/application_model.dart
//
// NOTE for team: this tracks a SEEKER'S application to a job
// (who applied, to what, and the status of THAT application).
// This is intentionally separate from JobModel.status, which currently
// lives on the job itself. Worth discussing whether job_model's status
// field should move here instead — applications_screen.dart and
// applicants_screen.dart will likely both read from this collection.
class ApplicationModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String seekerId;
  final String status; // 'pending' | 'reviewed' | 'successful' | 'rejected'
  final DateTime appliedAt;

  ApplicationModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.company,
    required this.seekerId,
    required this.status,
    required this.appliedAt,
  });

  factory ApplicationModel.fromMap(String id, Map<String, dynamic> map) {
    return ApplicationModel(
      id: id,
      jobId: map['jobId'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      company: map['company'] ?? '',
      seekerId: map['seekerId'] ?? '',
      status: map['status'] ?? 'pending',
      appliedAt: map['appliedAt'] != null
          ? (map['appliedAt'] as dynamic).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'jobTitle': jobTitle,
      'company': company,
      'seekerId': seekerId,
      'status': status,
      'appliedAt': appliedAt,
    };
  }
}
