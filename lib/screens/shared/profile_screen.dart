// lib/screens/shared/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/app_state.dart';
import '../../widgets/custom_button.dart';
import 'edit_profile_screen.dart';

// profile screen displays current user profile information
// Stateless profile screen that listens to the in-memory prototype state.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild whenever the local profile changes.
    return Consumer<AppState>(
      builder: (context, auth, _) {
        final user = auth.userProfile;

        // placeholder message is shown if user is not signed in
        // unauthenticated state is handled gracefully
        if (user == null) {
          return const Center(
            child: Text('Sign in to view your profile',
                style: TextStyle(color: AppConfig.textMuted)),
          );
        }

        // the main profile screen for the authenticated user
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile avatar shows a person icon with a blue background circle.
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

              // user's name
              Text(user.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppConfig.textDark)),
              const SizedBox(height: 4),

              // user's email address
              Text(user.email,
                  style: const TextStyle(
                      fontSize: 13, color: AppConfig.textMuted)),
              const SizedBox(height: 24),

              // edit profile button that goes to edit_profile_screen
              CustomButton(
                label: 'Edit Profile',
                icon: Icons.edit_outlined,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const EditProfileScreen()),
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
