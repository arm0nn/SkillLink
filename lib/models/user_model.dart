class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String? photoUrl;
  final String? resumeUrl;

  const UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      this.role = 'seeker',
      this.photoUrl,
      this.resumeUrl});
}
