import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/app_config.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SkillLinkApp());
}

class SkillLinkApp extends StatelessWidget {
  const SkillLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppAuthProvider(),
      child: MaterialApp(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppConfig.theme(),
        home: const SplashScreen(),
      ),
    );
  }
}
