// lib/screens/auth/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../provider/provider_dashboard.dart';
import '../seeker/seeker_dashboard.dart';
import 'landing_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

/// The permanent root of the app's navigation, not a one-time check.
///
/// This stays mounted for the whole app lifetime and rebuilds whenever
/// AppAuthProvider's state changes — that's what makes "log in" or
/// "register" actually navigate anywhere. LoginScreen/RegisterScreen are
/// NOT pushed with Navigator; they're swapped in/out right here, so they
/// stay inside the same Consumer that's watching auth state. If you
/// Navigator.push either of them from somewhere else, the auto-navigate-
/// after-login behavior will silently stop working for that instance.
///
/// LandingScreen is shown first, before Login, but only once per app
/// session (tracked by _hasSeenLanding) — logging out won't bring it
/// back until the app is fully restarted. That's a deliberate choice:
/// re-showing marketing copy every time someone logs out would be
/// annoying. If you'd rather show it every time logged-out state is
/// reached, just remove the _hasSeenLanding check below.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showRegister = false;
  bool _hasSeenLanding = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const _SplashLoading();
        }

        if (!auth.isLoggedIn) {
          if (!_hasSeenLanding) {
            return LandingScreen(
              onGetStarted: () => setState(() => _hasSeenLanding = true),
            );
          }

          return _showRegister
              ? RegisterScreen(
                  onSwitchToLogin: () => setState(() => _showRegister = false),
                )
              : LoginScreen(
                  onSwitchToRegister: () =>
                      setState(() => _showRegister = true),
                );
        }

        // Logged in: branch on role. Defaults to seeker if role is
        // somehow missing (e.g. accounts created before role existed).
        final role = auth.userProfile?.role ?? 'seeker';
        if (role == 'provider') {
          return const ProviderDashboard();
        }
        return const SeekerDashboard();
      },
    );
  }
}

class _SplashLoading extends StatelessWidget {
  const _SplashLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppConfig.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'SkillLink',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 28,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
