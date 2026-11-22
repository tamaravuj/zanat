import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../services/user_store.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Obaveštenja')),
      body: ListenableBuilder(
        listenable: UserStore.instance,
        builder: (context, _) {
          final u = UserStore.instance;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text(
                        'Push obaveštenja',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Uključi ili isključi sva obaveštenja',
                        style: TextStyle(fontSize: 10),
                      ),
                      value: u.pushEnabled,
                      activeColor: AppColors.secondary,
                      onChanged: u.setPush,
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    SwitchListTile(
                      title: const Text(
                        'Podsetnici za termine',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Podsetnik dan pre termina',
                        style: TextStyle(fontSize: 10),
                      ),
                      value: u.bookingReminders,
                      activeColor: AppColors.secondary,
                      onChanged: u.pushEnabled ? u.setReminders : null,
                    ),
                    const Divider(height: 1, color: Color(0xFFEEEEEE)),
                    SwitchListTile(
                      title: const Text(
                        'Novosti i ponude',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Nove radnje i promocije',
                        style: TextStyle(fontSize: 10),
                      ),
                      value: u.newsAndOffers,
                      activeColor: AppColors.secondary,
                      onChanged: u.pushEnabled ? u.setNews : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
