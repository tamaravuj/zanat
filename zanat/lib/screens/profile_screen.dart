import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../navigation/app_routes.dart';
import '../services/review_store.dart';
import '../services/user_store.dart';
import '../widgets/menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          UserStore.instance,
          ReviewStore.instance,
        ]),
        builder: (context, _) {
          final u = UserStore.instance;
          final reviewCount = ReviewStore.instance.byUser(UserStore.uid).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 39,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      initials(u.fullName),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Text(
                    u.fullName,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    u.email,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                    child: const Text(
                      'Izmeni profil',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              MenuCard(
                children: [
                  MenuTile(
                    icon: Icons.edit_outlined,
                    title: 'Lični podaci',
                    subtitle: u.fullName,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.editProfile),
                  ),
                  MenuTile(
                    icon: Icons.notifications_none,
                    title: 'Podešavanja obaveštenja',
                    subtitle: u.pushEnabled ? 'Uključena' : 'Isključena',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                  MenuTile(
                    icon: Icons.star_border,
                    title: 'Moje recenzije',
                    subtitle:
                        '$reviewCount ${pluralize(reviewCount, 'recenzija', 'recenzije', 'recenzija')}',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.myReviews),
                  ),
                  MenuTile(
                    icon: Icons.help_outline,
                    title: 'Pomoć i podrška',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.help),
                  ),
                  MenuTile(
                    icon: Icons.work_outline,
                    title: 'Pređi na poslovni nalog',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.owner),
                  ),
                  MenuTile(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'Admin panel (demo)',
                    onTap: () => Navigator.pushNamed(context, AppRoutes.admin),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (_) => false,
                ),
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text(
                  'Odjavi se',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 18,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'ZANAT verzija 1.0.0',
                  style: TextStyle(fontSize: 8, color: Color(0xFFA4A9AD)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
