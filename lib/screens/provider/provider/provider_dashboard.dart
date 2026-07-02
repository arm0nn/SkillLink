// lib/screens/provider/provider_dashboard.dart
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../seeker/seeker_dashboard.dart' show AppDrawer, DrawerMenuItem;
import '../shared/profile_screen.dart';
import 'my_jobs_screen.dart';
import 'post_job_screen.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  int _tabIndex = 0;

  final _tabs = const [
    MyJobsScreen(),
    ProfileScreen(),
  ];

  final _titles = const ['My Jobs', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: AppConfig.textDark),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          title: Text(
            _titles[_tabIndex],
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppConfig.textDark),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppConfig.border),
          ),
        ),
      ),
      drawer: AppDrawer(
        items: [
          DrawerMenuItem(
            icon: Icons.business_center_outlined,
            label: 'My Jobs',
            isActive: _tabIndex == 0,
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 0);
            },
          ),
          DrawerMenuItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'Post a Job',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PostJobScreen()),
              );
            },
          ),
          DrawerMenuItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: _tabIndex == 1,
            onTap: () {
              Navigator.pop(context);
              setState(() => _tabIndex = 1);
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
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppConfig.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Post Job',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PostJobScreen()),
                );
              },
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() => _tabIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppConfig.primaryBlue.withOpacity(0.1),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.business_center_outlined),
              selectedIcon: Icon(Icons.business_center_rounded,
                  color: AppConfig.primaryBlue),
              label: 'My Jobs'),
          NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon:
                  Icon(Icons.person_rounded, color: AppConfig.primaryBlue),
              label: 'Profile'),
        ],
      ),
    );
  }
}
