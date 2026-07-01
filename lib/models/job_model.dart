// lib/models/job_model.dart
class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String status; // 'pending' or 'successful'
  final String providerId; // uid of the provider who posted this job

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.status,
    required this.providerId,
  });

  /// Builds a JobModel from a Firestore document.
  /// [id] is the Firestore document ID (not stored inside the document body).
  factory JobModel.fromMap(String id, Map<String, dynamic> map) {
    return JobModel(
      id: id,
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      status: map['status'] ?? 'pending',
      providerId: map['providerId'] ?? '',
    );
  }

  /// Converts this JobModel into a map for writing to Firestore.
  /// id is excluded — Firestore stores it as the document ID, not a field.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'status': status,
      'providerId': providerId,
    };
  }
}
