// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Holds the current user's auth state + Firestore profile, and notifies
/// listeners on change. Wrap MaterialApp with ChangeNotifierProvider for
/// this in main.dart (see lib/main.dart).
///
/// Requires the `provider` package: provider: ^6.1.0
class AppAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _firebaseUser;
  UserModel? _userProfile;
  bool _isLoading = true;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _firebaseUser != null;

  AppAuthProvider() {
    _authService.authStateChanges.listen(_onAuthChanged);
  }

  Future<void> _onAuthChanged(User? user) async {
    _firebaseUser = user;
    if (user != null) {
      _userProfile = await _authService.getUserProfile(user.uid);
    } else {
      _userProfile = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Re-reads FirebaseAuth's current user + Firestore profile directly,
  /// instead of waiting for the authStateChanges stream to emit.
  ///
  /// Why this exists: login()/register() awaiting the Firebase call
  /// succeeding does NOT guarantee the authStateChanges listener above
  /// has already fired and updated _firebaseUser/_userProfile by the
  /// time that await returns — notifyListeners() from the stream can
  /// lag behind, so screens calling login()/register() and expecting
  /// isLoggedIn to flip true immediately after can see stale state.
  /// Calling this right after login()/register() forces an explicit,
  /// synchronous-as-possible refresh so the UI doesn't have to guess
  /// whether the stream has caught up yet.
  Future<void> refreshAuthState() async {
    final user = FirebaseAuth.instance.currentUser;
    _firebaseUser = user;
    if (user != null) {
      _userProfile = await _authService.getUserProfile(user.uid);
    } else {
      _userProfile = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email: email, password: password);
    await refreshAuthState();
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    await _authService.register(
        name: name, email: email, password: password, role: role);
    await refreshAuthState();
  }

  Future<void> logout() async {
    await _authService.logout();
    await refreshAuthState();
  }
}
