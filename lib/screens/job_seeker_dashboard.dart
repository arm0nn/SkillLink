// lib/screens/job_seeker_dashboard.dart
import 'package:flutter/material.dart';
import 'applied_jobs_screens.dart';
import 'personal_info_screen.dart';

class JobSeekerDashboard extends StatefulWidget {
  const JobSeekerDashboard({super.key});

  @override
  State<JobSeekerDashboard> createState() => _JobSeekerDashboardState();
}

class _JobSeekerDashboardState extends State<JobSeekerDashboard> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Defined inside build so each page rebuilds correctly on navigation
    final List<Widget> pages = [
      const DashboardHome(),
      const AppliedJobsScreen(),
      const PersonalInfoScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Applied Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard'),
          const SizedBox(height: 20),
          const Text('Quick Actions'),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAction(Icons.search, 'Browse'),
              _buildAction(Icons.work, 'Applications'),
              _buildAction(Icons.person, 'Profile'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Recent Applications'),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Job ${index + 1}'),
                  subtitle: Text('Company ${index + 1}'),
                  trailing: Text(index % 2 == 0 ? 'Pending' : 'Successful'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30),
        Text(label),
      ],
    );
  }
}