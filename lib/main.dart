import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_config.dart';
import 'providers/app_state.dart';
import 'screens/auth/splash_screen.dart';

void main() {
  runApp(const SkillLinkApp());
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppConfig.theme(),
        home: const SplashScreen(),
      ),
    );
  }
}
