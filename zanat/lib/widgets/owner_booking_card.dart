import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/booking.dart';
import '../services/booking_store.dart';
import 'status_badge.dart';

class OwnerBookingCard extends StatelessWidget {
  final Booking booking;
  const OwnerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final b = booking;
    final store = BookingStore.instance;
    final isToday = isSameDay(b.dateTime, DateTime.now());

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatTime(b.dateTime),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (!isToday)
                      Text(
                        '${b.dateTime.day}.${b.dateTime.month}.',
                        style: const TextStyle(
                          fontSize: 8,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFFE6EDF3),
                  child: Text(
                    initials(b.customerName),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.customerName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${b.serviceName} · ${b.durationMinutes} min',
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(b.status),
              ],
            ),
            if (b.isActive) ...[
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 11),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        foregroundColor: b.status == BookingStatus.pending
                            ? AppColors.primary
                            : AppColors.error,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          store.updateStatus(b.id, BookingStatus.cancelled),
                      child: Text(
                        b.status == BookingStatus.pending ? 'Odbij' : 'Otkaži',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => store.updateStatus(
                        b.id,
                        b.status == BookingStatus.pending
                            ? BookingStatus.upcoming
                            : BookingStatus.completed,
                      ),
                      child: Text(
                        b.status == BookingStatus.pending
                            ? 'Potvrdi'
                            : 'Završi',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
