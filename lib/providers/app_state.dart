import 'package:flutter/foundation.dart';

import '../models/application_model.dart';
import '../models/job_model.dart';
import '../models/user_model.dart';

/// In-memory state for UI/UX prototyping. Restarting restores demo content.
class AppState extends ChangeNotifier {
  UserModel? _user;
  final List<JobModel> _jobs = [
    JobModel(
        id: 'job-1',
        title: 'Barista',
        company: 'Kopi Kita',
        location: 'Kuala Lumpur',
        status: 'Open',
        providerId: 'demo-provider'),
    JobModel(
        id: 'job-2',
        title: 'Retail Assistant',
        company: 'Urban Mart',
        location: 'Petaling Jaya',
        status: 'Open',
        providerId: 'demo-provider'),
    JobModel(
        id: 'job-3',
        title: 'Junior UI Designer',
        company: 'Pixel Labs',
        location: 'Remote',
        status: 'Open',
        providerId: 'another-provider'),
  ];
  final List<ApplicationModel> _applications = [
    ApplicationModel(
        id: 'application-1',
        jobId: 'job-1',
        jobTitle: 'Barista',
        company: 'Kopi Kita',
        seekerId: 'demo-seeker',
        status: 'reviewed',
        appliedAt: DateTime.now().subtract(const Duration(days: 2))),
  ];
  final Set<String> _savedJobIds = {'job-2'};

  UserModel? get userProfile => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => false;
  List<JobModel> get jobs => List.unmodifiable(_jobs);
  Set<String> get savedJobIds => Set.unmodifiable(_savedJobIds);
  List<ApplicationModel> get applications => List.unmodifiable(_applications);

  void login(String email, String password) {
    _user = UserModel(
        uid: 'demo-seeker', name: 'Demo Seeker', email: email, role: 'seeker');
    notifyListeners();
  }

  void register(String name, String email, String password, String role) {
    _user = UserModel(
        uid: role == 'provider' ? 'demo-provider' : 'demo-seeker',
        name: name,
        email: email,
        role: role);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateName(String name) {
    final current = _user;
    if (current == null) return;
    _user = UserModel(
        uid: current.uid,
        name: name,
        email: current.email,
        role: current.role,
        photoUrl: current.photoUrl,
        resumeUrl: current.resumeUrl);
    notifyListeners();
  }

  void toggleSavedJob(String jobId) {
    _savedJobIds.contains(jobId)
        ? _savedJobIds.remove(jobId)
        : _savedJobIds.add(jobId);
    notifyListeners();
  }

  void applyToJob(JobModel job) {
    final uid = _user?.uid ?? 'demo-seeker';
    if (_applications
        .any((item) => item.jobId == job.id && item.seekerId == uid)) return;
    _applications.add(ApplicationModel(
        id: 'application-${_applications.length + 1}',
        jobId: job.id,
        jobTitle: job.title,
        company: job.company,
        seekerId: uid,
        status: 'pending',
        appliedAt: DateTime.now()));
    notifyListeners();
  }

  void postJob(
      {required String title,
      required String company,
      required String location}) {
    _jobs.insert(
        0,
        JobModel(
            id: 'job-${_jobs.length + 1}',
            title: title,
            company: company,
            location: location,
            status: 'Open',
            providerId: _user?.uid ?? 'demo-provider'));
    notifyListeners();
  }

  void updateApplicationStatus(String id, String status) {
    final index = _applications.indexWhere((item) => item.id == id);
    if (index == -1) return;
    final item = _applications[index];
    _applications[index] = ApplicationModel(
        id: item.id,
        jobId: item.jobId,
        jobTitle: item.jobTitle,
        company: item.company,
        seekerId: item.seekerId,
        status: status,
        appliedAt: item.appliedAt);
    notifyListeners();
  }
}
