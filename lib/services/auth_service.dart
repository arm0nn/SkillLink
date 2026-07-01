// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

/// Wraps FirebaseAuth + writes a matching profile doc to
/// Firestore's "users" collection on registration.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Emits the current FirebaseAuth user whenever auth state changes
  /// (login, logout, app restart with a cached session).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// Creates a FirebaseAuth account AND a matching Firestore profile doc
  /// at users/{uid}, since UserModel fields (name, role, etc.) aren't
  /// stored by FirebaseAuth itself.
  Future<UserCredential> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final profile = UserModel(uid: uid, name: name, email: email, role: role);

    await _db.collection('users').doc(uid).set(profile.toMap());

    return credential;
  }

  Future<void> logout() => _auth.signOut();

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  /// Fetches the Firestore profile for a given uid (the extra fields
  /// FirebaseAuth doesn't store: name, resumeUrl, etc).
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(uid, doc.data()!);
  }
}
