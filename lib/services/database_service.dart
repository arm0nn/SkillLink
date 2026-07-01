// lib/services/database_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model.dart';
import '../models/application_model.dart';

/// Single shared place for Firestore reads/writes.
/// Add to this file as new screens need new operations — avoid writing
/// Firestore calls directly inside widgets.
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _jobsRef => _db.collection('jobs');
  CollectionReference get _applicationsRef => _db.collection('applications');

  // ─── Jobs (seeker: job_feed_screen, provider: my_jobs_screen) ───

  Stream<List<JobModel>> getJobsStream() {
    return _jobsRef.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            JobModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  /// Jobs posted by a specific provider (provider/my_jobs_screen.dart).
  Stream<List<JobModel>> getJobsByProviderStream(String providerId) {
    return _jobsRef
        .where('providerId', isEqualTo: providerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                JobModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<String> postJob(JobModel job) async {
    final doc = await _jobsRef.add(job.toMap());
    return doc.id;
  }

  Future<void> deleteJob(String jobId) => _jobsRef.doc(jobId).delete();

  // ─── Saved jobs (seeker bookmarks) ───

  Future<void> saveJob(String uid, String jobId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('savedJobs')
        .doc(jobId)
        .set({'savedAt': Timestamp.now()});
  }

  Future<void> unsaveJob(String uid, String jobId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('savedJobs')
        .doc(jobId)
        .delete();
  }

  Stream<Set<String>> getSavedJobIdsStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('savedJobs')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((d) => d.id).toSet());
  }

  // ─── Applications (seeker: applications_screen, provider: applicants_screen) ───

  Future<void> applyToJob({
    required String jobId,
    required String jobTitle,
    required String company,
    required String seekerId,
  }) async {
    final application = ApplicationModel(
      id: '',
      jobId: jobId,
      jobTitle: jobTitle,
      company: company,
      seekerId: seekerId,
      status: 'pending',
      appliedAt: DateTime.now(),
    );
    await _applicationsRef.add(application.toMap());
  }

  /// Applications submitted by a seeker (seeker/applications_screen.dart).
  Stream<List<ApplicationModel>> getApplicationsBySeekerStream(String seekerId) {
    return _applicationsRef
        .where('seekerId', isEqualTo: seekerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  /// Applicants for a specific job (provider/applicants_screen.dart).
  Stream<List<ApplicationModel>> getApplicantsForJobStream(String jobId) {
    return _applicationsRef
        .where('jobId', isEqualTo: jobId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ApplicationModel.fromMap(
                doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateApplicationStatus(
      String applicationId, String newStatus) {
    return _applicationsRef.doc(applicationId).update({'status': newStatus});
  }
}
