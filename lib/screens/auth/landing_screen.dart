import 'package:flutter/material.dart';
import '../../config/app_config.dart';

class LandingScreen extends StatelessWidget {
  final VoidCallback onGetStarted;
  const LandingScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppConfig.primaryBlue, AppConfig.primaryBlueDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: SafeArea(
            child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 28),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 50),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                            color: Colors.white
                                                .withValues(alpha: 0.2))),
                                    child: const Icon(Icons.work_rounded,
                                        color: Colors.white, size: 20)),
                                const SizedBox(width: 11),
                                const Text('SkillLink',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.4)),
                              ]),
                              const SizedBox(height: 64),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 7),
                                  decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Text('OPPORTUNITY, SIMPLIFIED',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.4))),
                              const SizedBox(height: 20),
                              const Text(
                                  'Where skills meet\nthe right opportunity.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      height: 1.08,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -1.2)),
                              const SizedBox(height: 18),
                              Text(
                                  'Discover flexible work, build experience, or find the people who can move your business forward.',
                                  style: TextStyle(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                      fontSize: 15.5,
                                      height: 1.55)),
                              const SizedBox(height: 44),
                              const _FeatureGrid(),
                              const SizedBox(height: 48),
                              SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton.icon(
                                      onPressed: onGetStarted,
                                      iconAlignment: IconAlignment.end,
                                      icon: const Icon(
                                          Icons.arrow_forward_rounded),
                                      label: const Text('Explore SkillLink',
                                          style: TextStyle(
                                              fontSize: 15.5,
                                              fontWeight: FontWeight.w800)),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              AppConfig.primaryBlue,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16))))),
                              const SizedBox(height: 14),
                              Center(
                                  child: Text(
                                      'Designed for students and growing teams',
                                      style: TextStyle(
                                          color: Colors.white
                                              .withValues(alpha: 0.62),
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600))),
                            ]),
                      ),
                    )),
          ),
        ),
      );
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();
  @override
  Widget build(BuildContext context) => Row(children: const [
        Expanded(
            child: _Feature(
                icon: Icons.travel_explore_rounded,
                title: 'Discover',
                subtitle: 'Relevant local roles')),
        SizedBox(width: 12),
        Expanded(
            child: _Feature(
                icon: Icons.bolt_rounded,
                title: 'Connect',
                subtitle: 'Simple applications')),
      ]);
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Feature(
      {required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Colors.white, size: 23),
          const SizedBox(height: 18),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(subtitle,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.68), fontSize: 11.5))
        ]),
      );
}
