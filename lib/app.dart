import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/auth/view/login_screen.dart';

import 'features/products/data/repositories/product_repository.dart';
import 'features/products/viewmodel/product_viewmodel.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
          dispose: (_, client) => client.dispose(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(context.read<ApiClient>()),
        ),
        Provider<ProductRepository>(
          create: (context) => ProductRepository(context.read<ApiClient>()),
        ),
        ChangeNotifierProvider<AuthViewModel>(
          create: (context) =>
              AuthViewModel(repository: context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<ProductViewModel>(
          create: (context) =>
              ProductViewModel(repository: context.read<ProductRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'App Transaccional',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoginScreen(),
      ),
    );
  }
}
