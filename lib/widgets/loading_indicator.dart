// lib/widgets/loading_indicator.dart
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppConfig.primaryBlue),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(message!,
                style:
                    const TextStyle(color: AppConfig.textMuted, fontSize: 13)),
          ],
        ],
      ),
    );
  }
}
