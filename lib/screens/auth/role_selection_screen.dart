// lib/screens/auth/role_selection_screen.dart
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../widgets/custom_button.dart';
import '../seeker/seeker_dashboard.dart';
import '../provider/provider_dashboard.dart';

/// NOTE for team: NOT currently used. Role is now chosen via a toggle
/// directly on register_screen.dart, saved to UserModel.role at signup,
/// and splash_screen.dart branches on it after login. This screen is
/// dead code for now — kept around in case you later want a "switch
/// role" or "add a second role to my account" flow, which would need
/// this screen (or something like it) wired in separately.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'What brings you to SkillLink?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppConfig.textDark),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you\'d like to use the app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppConfig.textMuted),
              ),
              const SizedBox(height: 32),
              _RoleCard(
                icon: Icons.work_outline_rounded,
                title: 'I\'m looking for a job',
                subtitle: 'Browse listings and apply',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SeekerDashboard()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.business_center_outlined,
                title: 'I\'m hiring',
                subtitle: 'Post jobs and review applicants',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProviderDashboard()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppConfig.cardBorder),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppConfig.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppConfig.primaryBlue),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppConfig.textDark)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12.5, color: AppConfig.textMuted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppConfig.textFaint),
            ],
          ),
        ),
      ),
    );
  }
}
