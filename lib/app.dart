// ============================================================
// app.dart - Configuración principal de MaterialApp
// Define el tema Material 3 y la ruta inicial
// ============================================================

import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/view/login_screen.dart';

/// Widget raíz de la aplicación.
/// Configura Material Theme 3.0 y la navegación 1.0.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Transaccional',
      debugShowCheckedModeBanner: false,

      // Material Theme 3.0
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Navegación 1.0 - Ruta inicial
      home: const LoginScreen(),
    );
  }
}
