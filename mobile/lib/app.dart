import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/splash/presentation/splash_animation_screen.dart';
import 'features/cart/data/cart_provider.dart';
import 'features/wishlist/data/wishlist_provider.dart';
import 'features/orders/data/orders_provider.dart';
import 'features/profile/data/addresses_provider.dart';

import 'core/theme/theme_provider.dart';

class GrozzbyApp extends StatelessWidget {
  const GrozzbyApp({
    super.key,
    required this.router,
  });

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'Grozzby',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        isDark: false,
        highContrast: themeProvider.highContrast,
      ),
      darkTheme: AppTheme.getTheme(
        isDark: true,
        highContrast: themeProvider.highContrast,
      ),
      themeMode: themeProvider.themeMode,
      routerConfig: router,
    );
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final session = AppSession(prefs);
  final authRepository = AuthRepository();
  final themeProvider = ThemeProvider();
  await themeProvider.init(prefs);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(repository: authRepository)),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AddressesProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: GrozzbyApp(
        router: createAppRouter(
          session: session,
          authRepository: authRepository,
        ),
      ),
    ),
  );
}
