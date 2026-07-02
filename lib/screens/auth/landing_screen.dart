// lib/screens/auth/landing_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../widgets/custom_button.dart';


class LandingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const LandingScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppConfig.primaryBlue, AppConfig.primaryBlueDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo mark
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.25), width: 1.5),
                  ),
                  child: const Icon(Icons.work_rounded,
                      color: Colors.white, size: 40),
                ),
                const SizedBox(height: 28),

                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Skill',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                          letterSpacing: -0.8,
                        ),
                      ),
                      TextSpan(
                        text: 'Link',
                        style: TextStyle(
                          color: Color(0xFF93C5FD),
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'Find your next opportunity\nor your next great hire.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 2),

                // Feature highlights
                const _FeatureRow(
                  icon: Icons.search_rounded,
                  text: 'Browse jobs across Malaysia',
                ),
                const SizedBox(height: 14),
                const _FeatureRow(
                  icon: Icons.bolt_rounded,
                  text: 'Apply in just a few taps',
                ),
                const SizedBox(height: 14),
                const _FeatureRow(
                  icon: Icons.business_center_rounded,
                  text: 'Post listings as a hiring provider',
                ),

                const Spacer(flex: 3),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onGetStarted,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppConfig.primaryBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
