import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/booking.dart';

extension BookingStatusX on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.pending:
        return 'Čeka potvrdu';
      case BookingStatus.upcoming:
        return 'Potvrđeno';
      case BookingStatus.completed:
        return 'Završeno';
      case BookingStatus.cancelled:
        return 'Otkazano';
    }
  }
}

class StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg) = switch (status) {
      BookingStatus.upcoming => (
        const Color(0xFFE2EEE7),
        const Color(0xFF34745A),
      ),
      BookingStatus.pending => (
        const Color(0xFFF6EADC),
        const Color(0xFF99622D),
      ),
      BookingStatus.completed => (const Color(0xFFE8EDF2), AppColors.secondary),
      BookingStatus.cancelled => (
        const Color(0xFFF5E4E1),
        const Color(0xFFA54A4A),
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}
