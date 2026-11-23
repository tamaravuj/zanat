import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/booking.dart';
import '../../services/booking_store.dart';
import '../../services/owner_store.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/owner_booking_card.dart';
import '../../widgets/section_title.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  const OwnerDashboardScreen({super.key, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([
            BookingStore.instance,
            OwnerStore.instance,
          ]),
          builder: (context, _) {
            final now = DateTime.now();
            final all = BookingStore.instance.forShop(OwnerStore.ownerShopId);
            final valid = all
                .where((b) => b.status != BookingStatus.cancelled)
                .toList();
            final today =
                all
                    .where((b) => b.isActive && isSameDay(b.dateTime, now))
                    .toList()
                  ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
            final month = valid
                .where(
                  (b) =>
                      b.dateTime.year == now.year &&
                      b.dateTime.month == now.month,
                )
                .toList();
            final revenue = month.fold<int>(0, (s, b) => s + b.price);
            final next = today.where((b) => b.dateTime.isAfter(now)).toList();

            final weekStart = dateOnly(now)
                .subtract(Duration(days: now.weekday - 1));
            final counts = [
              for (var i = 0; i < 7; i++)
                valid
                    .where(
                      (b) => isSameDay(
                        b.dateTime,
                        weekStart.add(Duration(days: i)),
                      ),
                    )
                    .length,
            ];
            final maxCount = counts.fold<int>(1, (m, c) => c > m ? c : m);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            OwnerStore.instance.shopName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 8,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Dobar dan, ${OwnerStore.instance.ownerName}',
                            style: const TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        'MP',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  formatDateLong(now),
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.calendar_month_outlined,
                        value: '${month.length}',
                        label: 'Rezervacije ovog meseca',
                        note: formatPrice(revenue),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.people_outline,
                        value: '${today.length}',
                        label: 'Termina danas',
                        note: next.isEmpty
                            ? 'Nema narednih termina'
                            : 'Sledeći u ${formatTime(next.first.dateTime)}',
                      ),
                    ),
                  ],
                ),
                SectionTitle(
                  title: 'Današnji termini',
                  action: 'Vidi sve',
                  onAction: () => onTabSelected(2),
                ),
                if (today.isEmpty)
                  const SizedBox(
                    height: 150,
                    child: EmptyState(
                      icon: Icons.event_available_outlined,
                      title: 'Nema termina danas',
                      message: 'Slobodan dan!',
                    ),
                  ),
                for (final b in today) ...[
                  OwnerBookingCard(booking: b),
                  const SizedBox(height: 8),
                ],
                const SectionTitle(title: 'Aktivnost ove nedelje'),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var i = 0; i < 7; i++)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${counts[i]}',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 18,
                                  height: 8 + 62 * counts[i] / maxCount,
                                  decoration: BoxDecoration(
                                    color: i == now.weekday - 1
                                        ? AppColors.secondary
                                        : const Color(0xFFDCE6ED),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  const ['P', 'U', 'S', 'Č', 'P', 'S', 'N'][i],
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String note;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF2F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 19, color: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            note,
            style: const TextStyle(fontSize: 8, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
