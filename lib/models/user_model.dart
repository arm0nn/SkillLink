// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String role; // 'seeker' or 'provider'
  final String? photoUrl;
  final String? resumeUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.role = 'seeker',
    this.photoUrl,
    this.resumeUrl,
  });

  /// Builds a UserModel from a Firestore document.
  /// [uid] is the Firestore document ID, which we set to match
  /// FirebaseAuth's user.uid when the account is created.
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'seeker',
      photoUrl: map['photoUrl'],
      resumeUrl: map['resumeUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'photoUrl': photoUrl,
      'resumeUrl': resumeUrl,
    };
  }
}
