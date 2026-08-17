import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../provider/provider_dashboard.dart';
import '../seeker/seeker_dashboard.dart';
import 'auth_layout.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthLayout(
        eyebrow: 'Choose your path',
        title: 'What brings you here?',
        subtitle:
            'Select the experience that best matches what you want to do today.',
        child: Column(children: [
          _RoleCard(
              icon: Icons.search_rounded,
              title: 'I’m looking for work',
              subtitle:
                  'Explore roles, save opportunities, and track applications.',
              action: 'Find opportunities',
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const SeekerDashboard()))),
          const SizedBox(height: 14),
          _RoleCard(
              icon: Icons.business_center_outlined,
              title: 'I’m hiring talent',
              subtitle:
                  'Create listings and keep track of promising applicants.',
              action: 'Start hiring',
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProviderDashboard()))),
        ]),
      );
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String action;
  final VoidCallback onTap;
  const _RoleCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.action,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
      color: AppConfig.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppConfig.chipBg,
                        borderRadius: BorderRadius.circular(15)),
                    child: Icon(icon, color: AppConfig.primaryBlue)),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppConfig.textDark)),
                      const SizedBox(height: 4),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: AppConfig.textMuted)),
                      const SizedBox(height: 10),
                      Text(action,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppConfig.primaryBlue))
                    ])),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppConfig.textFaint, size: 20),
              ]))));
}
