import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/_core/theme_config.dart';
import 'package:tiktik_clone/views/screens/auth/login_screen.dart';

import '_core/initial_bindings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          initialBinding: InitBindings(),
          debugShowCheckedModeBanner: false,
          title: 'TikTok Clone',
          theme: AppTheme.darkTheme,
          home: const LoginScreen(),
        );
      },
    );
  }
}
