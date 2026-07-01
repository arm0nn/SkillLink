// lib/widgets/applicant_card.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/application_model.dart';
import '../utils/date_formatter.dart';

class ApplicantCard extends StatelessWidget {
  final ApplicationModel application;
  final ValueChanged<String> onStatusChange;

  const ApplicantCard({
    super.key,
    required this.application,
    required this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppConfig.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppConfig.primaryBlue.withOpacity(0.12),
                child: const Icon(Icons.person_outline_rounded,
                    color: AppConfig.primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NOTE for team: applicant's name/email needs a join
                    // against users/{seekerId} — ApplicationModel only
                    // stores seekerId. Fetch the UserModel where this
                    // card is built, or denormalize name/email onto
                    // ApplicationModel at write-time if that's simpler.
                    Text('Applicant ${application.seekerId.substring(0, 6)}',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppConfig.textDark)),
                    Text(
                      'Applied ${DateFormatter.relative(application.appliedAt)}',
                      style: const TextStyle(
                          fontSize: 11, color: AppConfig.textFaint),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: application.status,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: AppConfig.chipBg,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'reviewed', child: Text('Reviewed')),
              DropdownMenuItem(value: 'successful', child: Text('Successful')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
            onChanged: (value) {
              if (value != null) onStatusChange(value);
            },
          ),
        ],
      ),
    );
  }
}
