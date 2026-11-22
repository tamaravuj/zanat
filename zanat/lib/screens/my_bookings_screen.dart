import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/booking.dart';
import '../navigation/app_routes.dart';
import '../services/booking_store.dart';
import '../services/user_store.dart';
import '../widgets/appointment_card.dart';
import '../widgets/empty_state.dart';

class MyBookingsScreen extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  const MyBookingsScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Moji termini'),
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Predstojeći'),
              Tab(text: 'Završeni'),
              Tab(text: 'Otkazani'),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: BookingStore.instance,
          builder: (context, _) {
            final mine = BookingStore.instance.forUser(UserStore.uid);
            final upcoming = mine.where((b) => b.isActive).toList()
              ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
            final completed =
                mine.where((b) => b.status == BookingStatus.completed).toList()
                  ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
            final cancelled =
                mine.where((b) => b.status == BookingStatus.cancelled).toList()
                  ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

            return TabBarView(
              children: [
                _list(
                  context,
                  upcoming,
                  EmptyState(
                    icon: Icons.calendar_month_outlined,
                    title: 'Nema predstojećih termina',
                    message: 'Novi termin možeš zakazati u nekoliko koraka.',
                    actionLabel: 'Pronađi majstora',
                    onAction: () => onTabSelected(1),
                  ),
                ),
                _list(
                  context,
                  completed,
                  const EmptyState(
                    icon: Icons.history,
                    title: 'Nema završenih termina',
                    message: 'Ovde će se pojaviti termini koje si obavio/la.',
                  ),
                ),
                _list(
                  context,
                  cancelled,
                  const EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'Nema otkazanih termina',
                    message: 'Otkazani termini će se prikazati ovde.',
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<Booking> items, Widget empty) {
    if (items.isEmpty) return empty;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => AppointmentCard(
        booking: items[i],
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.bookingDetails,
          arguments: items[i].id,
        ),
      ),
    );
  }
}
