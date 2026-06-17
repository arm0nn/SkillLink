// lib/models/user_model.dart
class UserModel {
  final String name;
  final String email;
  final String? photoUrl;
  final String? resumeUrl;

  UserModel({
    required this.name,
    required this.email,
    this.photoUrl,
    this.resumeUrl,
  });
}