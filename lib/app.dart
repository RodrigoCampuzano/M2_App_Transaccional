import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Transaccional',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const LoginScreen(),
    );
  }
}
