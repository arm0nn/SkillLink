import 'package:flutter/material.dart';
import '../../config/app_config.dart';

class AuthLayout extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget child;
  final Widget? leading;

  const AuthLayout({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.child,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: constraints.maxHeight - 44),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (leading != null) ...[
                            leading!,
                            const SizedBox(width: 12)
                          ],
                          const _BrandMark(),
                          const SizedBox(width: 10),
                          const Text('SkillLink',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppConfig.textDark,
                                  letterSpacing: -0.4)),
                        ],
                      ),
                      const SizedBox(height: 44),
                      Text(eyebrow.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppConfig.primaryBlue,
                              letterSpacing: 1.5)),
                      const SizedBox(height: 10),
                      Text(title,
                          style: const TextStyle(
                              fontSize: 30,
                              height: 1.12,
                              fontWeight: FontWeight.w800,
                              color: AppConfig.textDark,
                              letterSpacing: -0.8)),
                      const SizedBox(height: 10),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 14.5,
                              height: 1.5,
                              color: AppConfig.textMuted)),
                      const SizedBox(height: 28),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppConfig.cardBorder),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x0D0F172A),
                                blurRadius: 30,
                                offset: Offset(0, 12))
                          ],
                        ),
                        child: child,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AuthBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded, size: 20),
        style: IconButton.styleFrom(
            backgroundColor: Colors.white, foregroundColor: AppConfig.textDark),
      );
}

class AuthSwitchPrompt extends StatelessWidget {
  final String prompt;
  final String action;
  final VoidCallback onTap;
  const AuthSwitchPrompt(
      {super.key,
      required this.prompt,
      required this.action,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(prompt,
              style:
                  const TextStyle(color: AppConfig.textMuted, fontSize: 13.5)),
          TextButton(
              onPressed: onTap,
              child: Text(action,
                  style: const TextStyle(fontWeight: FontWeight.w800))),
        ],
      );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();
  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
            color: AppConfig.primaryBlue,
            borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.work_rounded, color: Colors.white, size: 19),
      );
}
