// lib/widgets/job_card.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final bool isSaved;
  final VoidCallback onTap;
  final VoidCallback onSaveToggle;

  const JobCard({
    super.key,
    required this.job,
    required this.isSaved,
    required this.onTap,
    required this.onSaveToggle,
  });

  Color get _logoColor {
    final colors = [
      AppConfig.primaryBlue,
      const Color(0xFFFF6B35),
      const Color(0xFF7C3AED),
      const Color(0xFFEC4899),
      const Color(0xFF059669),
      const Color(0xFFD97706),
      const Color(0xFF0891B2),
    ];
    if (job.company.isEmpty) return colors[0];
    final index = job.company.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[index];
  }

  String get _logoInitials {
    final words = job.company.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
    return (words[0].substring(0, 1) + words[1].substring(0, 1)).toUpperCase();
  }

  Map<String, Color> get _statusColors {
    switch (job.status) {
      case 'successful':
        return {'bg': const Color(0xFFF0FDF4), 'text': const Color(0xFF16A34A)};
      case 'pending':
        return {'bg': const Color(0xFFFFFBEB), 'text': const Color(0xFFD97706)};
      default:
        return {'bg': AppConfig.chipBg, 'text': AppConfig.textMuted};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = _statusColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConfig.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppConfig.textDark.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _logoColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _logoInitials,
                          style: TextStyle(
                            color: _logoColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppConfig.textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            job.company,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppConfig.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onSaveToggle,
                      child: Icon(
                        isSaved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        color: isSaved
                            ? AppConfig.primaryBlue
                            : const Color(0xFFCBD5E1),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14, color: AppConfig.textFaint),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        job.location,
                        style: const TextStyle(
                            fontSize: 12, color: AppConfig.textMuted),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColors['bg'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: statusColors['text'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
