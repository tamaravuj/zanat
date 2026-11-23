import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking.dart';
import '../../services/booking_store.dart';
import '../../services/owner_store.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/owner_booking_card.dart';

class OwnerBookingsScreen extends StatelessWidget {
  const OwnerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: BookingStore.instance,
      builder: (context, _) {
        final now = DateTime.now();
        final all = BookingStore.instance.forShop(OwnerStore.ownerShopId);
        List<Booking> sorted(Iterable<Booking> it) =>
            it.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));

        final today = sorted(
          all.where((b) => b.isActive && isSameDay(b.dateTime, now)),
        );
        final upcoming = sorted(
          all.where(
            (b) => b.isActive && dateOnly(b.dateTime).isAfter(dateOnly(now)),
          ),
        );
        final done = sorted(all.where((b) => !b.isActive)).reversed.toList();

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Rezervacije'),
              bottom: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                labelStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: 'Danas (${today.length})'),
                  const Tab(text: 'Predstojeće'),
                  const Tab(text: 'Završene'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _list(today, 'Nema termina danas'),
                _list(upcoming, 'Nema predstojećih termina'),
                _list(done, 'Nema završenih termina'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _list(List<Booking> items, String emptyTitle) {
    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.inbox_outlined,
        title: emptyTitle,
        message: 'Nove rezervacije će se pojaviti ovde.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 11),
      itemBuilder: (_, i) => OwnerBookingCard(booking: items[i]),
    );
  }
}
