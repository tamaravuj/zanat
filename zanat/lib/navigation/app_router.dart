import 'package:flutter/material.dart';
import 'package:zanat/screens/edit_profile_screen.dart';
import 'package:zanat/screens/help_screen.dart';
import 'package:zanat/screens/my_reviews_screen.dart';
import 'package:zanat/screens/notifications_screen.dart';
import 'package:zanat/screens/owner/owner_hours_screen.dart';
import 'package:zanat/screens/owner/owner_info_screen.dart';
import 'package:zanat/screens/owner/owner_services_screen.dart';
import 'package:zanat/screens/owner/owner_shell.dart';

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
import '../screens/booking_screen.dart';
import '../models/booking.dart';
import '../screens/booking_confirmation_screen.dart';
import '../screens/shop_reviews_screen.dart';
import '../screens/booking_details_screen.dart';

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
        final tab = settings.arguments as int? ?? 0;
        return MaterialPageRoute(builder: (_) => MainShell(initialIndex: tab));

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

      case AppRoutes.booking:
        final shop = settings.arguments as Shop;

        return MaterialPageRoute(builder: (_) => BookingScreen(shop: shop));

      case AppRoutes.bookingConfirmation:
        final booking = settings.arguments as Booking;
        return MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(booking: booking),
        );
      case AppRoutes.shopReviews:
        final shop = settings.arguments as Shop;
        return MaterialPageRoute(builder: (_) => ShopReviewsScreen(shop: shop));

      case AppRoutes.bookingDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BookingDetailsScreen(bookingId: id),
        );
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.myReviews:
        return MaterialPageRoute(builder: (_) => const MyReviewsScreen());
      case AppRoutes.help:
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      case AppRoutes.owner:
        return MaterialPageRoute(builder: (_) => const OwnerShell());
      case AppRoutes.ownerInfo:
        return MaterialPageRoute(builder: (_) => const OwnerInfoScreen());
      case AppRoutes.ownerServices:
        return MaterialPageRoute(builder: (_) => const OwnerServicesScreen());
      case AppRoutes.ownerHours:
        return MaterialPageRoute(builder: (_) => const OwnerHoursScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ekran nije pronađen'))),
        );
    }
  }
}
