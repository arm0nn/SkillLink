// lib/screens/seeker/seeker_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_config.dart';
import '../../providers/auth_provider.dart';
import '../shared/profile_screen.dart';
import 'applications_screen.dart';
import 'job_feed_screen.dart';

class SeekerDashboard extends StatefulWidget {
  const SeekerDashboard({super.key});

  @override
  State<SeekerDashboard> createState() => _SeekerDashboardState();
}

class _SeekerDashboardState extends State<SeekerDashboard> {
  int _tabIndex = 0;

  final _tabs = const [
    JobFeedScreen(),
    ApplicationsScreen(),
    ProfileScreen(),
  ];

  final _titles = const ['Jobs', 'My Applications', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: AppDrawer(
        items: [
          DrawerMenuItem(
            icon: Icons.work_outline_rounded,
            label: 'Job Listings',
            isActive: _tabIndex == 0,
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 0);
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
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support — coming soon')),
              );
            },
          ),
        ],
      ),
      body: _tabs[_tabIndex],
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppConfig.textDark),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppConfig.border),
        ),
      ),
    );
  }
}

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

/// Data for a single drawer menu item.
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

/// Shared hamburger drawer (used by both seeker + provider dashboards).
///
/// Takes its menu items as data via [items], so each dashboard defines
/// its own labels/icons/destinations instead of this widget guessing
/// what a given label "means" for whichever screen is using it. Each
/// item's onTap is responsible for closing the drawer (Navigator.pop)
/// itself if that's desired.
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
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
