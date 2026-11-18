import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/formatters.dart';
import '../models/booking.dart';
import '../navigation/app_routes.dart';
import '../widgets/primary_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;
  const BookingConfirmationScreen({super.key, required this.booking});

  void _goTo(BuildContext context, int tab) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.shell,
      (_) => false,
      arguments: tab,
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = booking;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goTo(context, 0);
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            child: Column(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2EEE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 44,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'REZERVACIJA POTVRĐENA',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Vidimo se u ${weekdayAcc(b.dateTime)}!',
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tvoj termin je potvrđen. Možeš ga pratiti i otkazati u sekciji Moji termini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(11),
                            child: Image.network(
                              b.shopImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 50,
                                height: 50,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.shopName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  b.serviceName,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1, color: Color(0xFFD9D9D6)),
                      ),
                      Row(
                        children: [
                          _cell('DATUM', formatDateShort(b.dateTime)),
                          _cell('VREME', formatTime(b.dateTime)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _cell('TRAJANJE', '${b.durationMinutes} min'),
                          _cell('CENA', formatPrice(b.price)),
                        ],
                      ),
                      const SizedBox(height: 17),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0ED),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Text(
                          b.code,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: 'Pogledaj moje termine',
                  onPressed: () => _goTo(context, 2),
                ),
                const SizedBox(height: 8),
                PrimaryButton(
                  label: 'Nazad na početnu',
                  variant: AppButtonVariant.ghost,
                  onPressed: () => _goTo(context, 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cell(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
