class ApplicationModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String company;
  final String seekerId;
  final String status;
  final DateTime appliedAt;

  const ApplicationModel(
      {required this.id,
      required this.jobId,
      required this.jobTitle,
      required this.company,
      required this.seekerId,
      required this.status,
      required this.appliedAt});
}
