import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'main_shell.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.shell:
        return MaterialPageRoute(builder: (_) => const MainShell());
      // Ostale rute dodajemo uz svaki novi ekran (commitovi 7-14).
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ekran nije pronađen'))),
        );
    }
  }
}
