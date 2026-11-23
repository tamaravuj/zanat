import 'package:flutter/material.dart';
import 'package:zanat/models/shop.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/category_ui.dart';
import '../../navigation/app_routes.dart';
import '../../services/mock_data.dart';
import '../../services/owner_store.dart';
import '../../widgets/menu_tile.dart';
import '../../widgets/primary_button.dart';

class OwnerShopScreen extends StatelessWidget {
  const OwnerShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shop = MockData.shopById(OwnerStore.ownerShopId);
    return Scaffold(
      appBar: AppBar(title: const Text('Moja radnja')),
      body: ListenableBuilder(
        listenable: OwnerStore.instance,
        builder: (context, _) {
          final store = OwnerStore.instance;
          final openDays = store.schedule.where((d) => d.open).length;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(
                    shop.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: AppColors.secondary),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 15, 3, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.shopName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${shop.category.singular} · ${shop.district}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              MenuCard(
                children: [
                  MenuTile(
                    icon: Icons.edit_outlined,
                    title: 'Osnovni podaci',
                    subtitle: 'Naziv, opis, adresa',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.ownerInfo),
                  ),
                  MenuTile(
                    icon: Icons.content_cut,
                    title: 'Usluge i cene',
                    subtitle: '${store.services.length} aktivnih usluga',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.ownerServices),
                  ),
                  MenuTile(
                    icon: Icons.access_time,
                    title: 'Radno vreme',
                    subtitle: '$openDays radnih dana nedeljno',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.ownerHours),
                  ),
                  MenuTile(
                    icon: Icons.notifications_none,
                    title: 'Obaveštenja',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              PrimaryButton(
                label: 'Vrati se na korisnički nalog',
                variant: AppButtonVariant.ghost,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
