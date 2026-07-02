// lib/screens/seeker/seeker_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../shared/profile_screen.dart';
import 'applications_screen.dart';
import 'job_feed_screen.dart';

// the main dashboard for job seekers  
// uses a stateful widget to manage the selected tab index and update UI accordingly
// switches between jobs feed, applications, and profile screens based on the selected tab  
class SeekerDashboard extends StatefulWidget {
  const SeekerDashboard({super.key});

  @override
  State<SeekerDashboard> createState() => _SeekerDashboardState();
}

class _SeekerDashboardState extends State<SeekerDashboard> {
  // tracks which tab is currently selected (0 = Jobs, 1 = Applications, 2 = Profile)
  int _tabIndex = 0;

  // the screens corresponding to each index 
  final _tabs = const [
    JobFeedScreen(),
    ApplicationsScreen(),
    ProfileScreen(),
  ];

  // titles used in the app bar at the bottom
  final _titles = const ['Jobs', 'My Applications', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context), // Custom app bar defined below.
      drawer: AppDrawer(
        // reusable drawer widget
        items: [
          DrawerMenuItem(
            icon: Icons.work_outline_rounded,
            label: 'Job Listings',
            isActive: _tabIndex == 0, // highlights the active item
            onTap: () {
              Navigator.pop(context); // close the drawer
              setState(() => _tabIndex = 0); // switch to Jobs tab
            },
          ),
          DrawerMenuItem(
            icon: Icons.description_outlined,
            label: 'My Applications',
            isActive: _tabIndex == 1,
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 1);
            },
          ),
          DrawerMenuItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: _tabIndex == 2,
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 2);
            },
          ),
          DrawerMenuItem(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            // help and support message
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support — coming soon')),
              );
            },
          ),
        ],
      ),
      // The body changes based on the selected tab
      body: _tabs[_tabIndex],
      // bottom navigation bar for switching between jobs, applications, and profile quickly
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppConfig.primaryBlue.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.work_outline_rounded),
              selectedIcon: Icon(Icons.work_rounded, color: AppConfig.primaryBlue),
              label: 'Jobs'),
          NavigationDestination(
              icon: Icon(Icons.description_outlined),
              selectedIcon:
                  Icon(Icons.description_rounded, color: AppConfig.primaryBlue),
              label: 'Applications'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon:
                  Icon(Icons.person_rounded, color: AppConfig.primaryBlue),
              label: 'Profile'),
        ],
      ),
    );
  }

  // the APP bar
  // the app bar contains a button for hamburger menu, the logo of the app in the middle, and profile icon on the right
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        // hamburger menu button that opens the drawer on the left  
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppConfig.textDark),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),

        // Title: shows the "SkillLink" logo on the Jobs tab, otherwise shows the tab name
        title: Center(
          child: _tabIndex == 0
              ? const _SkillLinkLogo()
              : Text(
                  _titles[_tabIndex],
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppConfig.textDark),
                ),
        ),
        // profile avatar on the top right that takes you to the profile tab when clicked
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Consumer<AppAuthProvider>(
              builder: (context, auth, _) {
                return GestureDetector(
                  onTap: () {
                    setState(() => _tabIndex = 2); // jump to Profile tab
                  },
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppConfig.chipBg,
                      border: Border.all(color: AppConfig.border, width: 1.5),
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        size: 20, color: AppConfig.textMuted),
                  ),
                );
              },
            ),
          ),
        ],
        // bottom border to separate the app bar from the body.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppConfig.border),
        ),
      ),
    );
  }
}

// SkillLink logo widget for the app bar for the jobs tab
// displays the "SkillLink" brand name with "Skill" in dark and "Link" in blue
class _SkillLinkLogo extends StatelessWidget {
  const _SkillLinkLogo();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Skill',
            style: TextStyle(
                color: AppConfig.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5),
          ),
          TextSpan(
            text: 'Link',
            style: TextStyle(
                color: AppConfig.primaryBlue,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5),
          ),
        ],
      ),
    );
  }
}

// DRAWER MENU ITEM CLASS
// Data for a single drawer menu item
// [isActive] determines if the item is visually highlighted
// [onTap] is the callback executed when the item is tapped
class DrawerMenuItem {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });
}

// REUSABLE APP DRAWER
// shared hamburger drawer for both job seeker and job provider
// Takes its menu items as data via [items], so each dashboard defines its own labels/icons/destinations 
class AppDrawer extends StatelessWidget {
  final List<DrawerMenuItem> items;

  const AppDrawer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DRAWER HEADER
            // gradient background with the white logo and the user's name
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppConfig.primaryBlue, AppConfig.primaryBlueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Consumer<AppAuthProvider>(
                builder: (context, auth, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _SkillLinkLogoWhite(),
                      const SizedBox(height: 6),
                      Text(
                        // shows the user's name if logged in, otherwise there's a fallback message
                        auth.userProfile?.name ?? 'Find your dream job today',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.85), fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            // DRAWER MENU ITEMS
            // builds each item from the provided list
            // active items are highlighted with a blue background and bold text
            for (final item in items)
              ListTile(
                leading: Icon(item.icon,
                    color: item.isActive
                        ? AppConfig.primaryBlue
                        : AppConfig.textMuted),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontWeight:
                        item.isActive ? FontWeight.w700 : FontWeight.w500,
                    color: item.isActive
                        ? AppConfig.primaryBlue
                        : AppConfig.textDark,
                  ),
                ),
                tileColor:
                    item.isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
                onTap: item.onTap,
              ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Divider(color: AppConfig.border),
            ),

            // spacer helps push the logout button to the bottom of the drawer
            const Spacer(),

            // LOGOUT BUTTON
            // A red button that calls the auth provider's logout method
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);          // close the drawer first
                    await context.read<AppAuthProvider>().logout();
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Log Out',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SKILLLINK LOGO WHITE
// displays "Skill" in white and "Link" in light blue
// used inside the drawer header gradient background
class _SkillLinkLogoWhite extends StatelessWidget {
  const _SkillLinkLogoWhite();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Skill',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5),
          ),
          TextSpan(
            text: 'Link',
            style: TextStyle(
                color: Color(0xFF93C5FD),
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5),
          ),
        ],
      ),
    );
  }
}
