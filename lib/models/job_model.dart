class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String status;
  final String providerId;

  const JobModel(
      {required this.id,
      required this.title,
      required this.company,
      required this.location,
      required this.status,
      required this.providerId});
}
