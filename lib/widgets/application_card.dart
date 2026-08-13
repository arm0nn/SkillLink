// lib/widgets/application_card.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/application_model.dart';
import '../utils/date_formatter.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

  Map<String, Color> get _statusColors {
    switch (application.status) {
      case 'successful':
        return {'bg': const Color(0xFFF0FDF4), 'text': const Color(0xFF16A34A)};
      case 'rejected':
        return {'bg': const Color(0xFFFEF2F2), 'text': const Color(0xFFDC2626)};
      case 'reviewed':
        return {'bg': const Color(0xFFEFF6FF), 'text': AppConfig.primaryBlue};
      default:
        return {'bg': const Color(0xFFFFFBEB), 'text': const Color(0xFFD97706)};
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConfig.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  application.jobTitle,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppConfig.textDark),
                ),
                const SizedBox(height: 2),
                Text(
                  application.company,
                  style:
                      const TextStyle(fontSize: 12, color: AppConfig.textMuted),
                ),
                const SizedBox(height: 6),
                Text(
                  'Applied ${DateFormatter.relative(application.appliedAt)}',
                  style:
                      const TextStyle(fontSize: 11, color: AppConfig.textFaint),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colors['bg'],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              application.status,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: colors['text']),
            ),
          ),
        ],
      ),
    );
  }
}
