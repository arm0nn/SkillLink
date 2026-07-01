// lib/screens/shared/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>(
      builder: (context, auth, _) {
        final user = auth.userProfile;

        if (user == null) {
          return const Center(
            child: Text('Sign in to view your profile',
                style: TextStyle(color: AppConfig.textMuted)),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppConfig.primaryBlue.withOpacity(0.1),
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? const Icon(Icons.person_outline_rounded,
                        size: 44, color: AppConfig.primaryBlue)
                    : null,
              ),
              const SizedBox(height: 14),
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.textDark)),
              const SizedBox(height: 4),
              Text(user.email,
                  style:
                      const TextStyle(fontSize: 13, color: AppConfig.textMuted)),
              const SizedBox(height: 24),

              // Only show the resume card if a resume exists
              if (user.resumeUrl != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppConfig.cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description_outlined,
                          color: AppConfig.primaryBlue),
                      const SizedBox(width: 10),
                      const Expanded(
                          child: Text('Resume uploaded',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppConfig.textDark))),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppConfig.textFaint),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
              CustomButton(
                label: 'Edit Profile',
                icon: Icons.edit_outlined,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}