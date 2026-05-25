import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/products/data/repositories/product_repository.dart';

import 'features/auth/viewmodel/auth_viewmodel.dart';
import 'features/products/viewmodel/product_viewmodel.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();

  final authRepository = AuthRepository(apiClient);
  final productRepository = ProductRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              AuthViewModel(repository: authRepository, apiClient: apiClient),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(repository: productRepository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
