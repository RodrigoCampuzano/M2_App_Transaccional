import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/auth/view/login_screen.dart';

import 'features/products/data/repositories/product_repository.dart';
import 'features/products/viewmodel/product_viewmodel.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final ProductRepository _productRepository;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
    _authRepository = AuthRepository(_apiClient);
    _productRepository = ProductRepository(_apiClient);
  }

  @override
  void dispose() {
    _apiClient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            repository: _authRepository,
            apiClient: _apiClient,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(repository: _productRepository),
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
