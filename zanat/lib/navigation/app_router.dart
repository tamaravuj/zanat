import 'package:flutter/material.dart';

import '../models/search_filters.dart';
import '../models/shop.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/search_results_screen.dart';
import '../screens/shop_details_screen.dart';
import 'app_routes.dart';
import 'main_shell.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.shell:
        return MaterialPageRoute(builder: (_) => const MainShell());
      case AppRoutes.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case AppRoutes.searchResults:
        final filters =
            settings.arguments as SearchFilters? ?? const SearchFilters();
        return MaterialPageRoute(
          builder: (_) => SearchResultsScreen(filters: filters),
        );
      case AppRoutes.shopDetails:
        final shop = settings.arguments as Shop;
        return MaterialPageRoute(builder: (_) => ShopDetailsScreen(shop: shop));
      // Ostale rute dodajemo ISPRED default-a.
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ekran nije pronađen'))),
        );
    }
  }
}
