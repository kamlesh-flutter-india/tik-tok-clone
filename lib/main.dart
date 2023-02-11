import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tiktik_clone/_core/theme_config.dart';
import 'package:tiktik_clone/views/screens/auth/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TikTok Clone',
          theme: AppTheme.darkTheme,
          home: LoginScreen(),
        );
      },
    );
  }
}
