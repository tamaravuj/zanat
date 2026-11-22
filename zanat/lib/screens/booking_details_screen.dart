import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/category_ui.dart';
import '../core/utils/formatters.dart';
import '../models/booking.dart';
import '../navigation/app_routes.dart';
import '../services/booking_store.dart';
import '../services/mock_data.dart';
import '../services/review_store.dart';
import '../widgets/primary_button.dart';
import '../widgets/review_sheet.dart';
import '../widgets/status_badge.dart';

class BookingDetailsScreen extends StatelessWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  Future<void> _cancel(BuildContext context, Booking b) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Otkazati termin?'),
        content: Text(
          '${b.shopName} · ${formatDateShort(b.dateTime)} u ${formatTime(b.dateTime)}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Ne'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Otkaži termin',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok == true) {
      BookingStore.instance.updateStatus(b.id, BookingStatus.cancelled);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Termin je otkazan.')));
      }
    }
  }

  void _copy(BuildContext context, Booking b) {
    final text =
        '${b.shopName}\n${b.serviceName}\n'
        '${formatDateLong(b.dateTime)} u ${formatTime(b.dateTime)}\n'
        '${b.shopAddress}\nBroj rezervacije: ${b.code}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detalji termina su kopirani.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        BookingStore.instance,
        ReviewStore.instance,
      ]),
      builder: (context, _) {
        final b = BookingStore.instance.byId(bookingId);
        if (b == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Termin nije pronađen.')),
          );
        }
        final shop = MockData.shopById(b.shopId);

        final (
          IconData heroIcon,
          Color heroColor,
          Color heroBg,
          String heroText,
        ) = switch (b.status) {
          BookingStatus.upcoming => (
            Icons.check,
            AppColors.success,
            const Color(0xFFE2EEE7),
            'Termin je potvrđen i čeka te.',
          ),
          BookingStatus.pending => (
            Icons.hourglass_top,
            const Color(0xFF99622D),
            const Color(0xFFF6EADC),
            'Radnja još nije potvrdila termin.',
          ),
          BookingStatus.completed => (
            Icons.check,
            AppColors.secondary,
            const Color(0xFFE8EDF2),
            'Termin je završen.',
          ),
          BookingStatus.cancelled => (
            Icons.close,
            AppColors.error,
            const Color(0xFFF5E4E1),
            'Termin je otkazan.',
          ),
        };

        return Scaffold(
          appBar: AppBar(title: const Text('Detalji termina')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Column(
                children: [
                  Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      color: heroBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(heroIcon, color: heroColor),
                  ),
                  const SizedBox(height: 10),
                  StatusBadge(b.status),
                  const SizedBox(height: 10),
                  Text(
                    '${weekdayName(b.dateTime)}, ${b.dateTime.day}. ${monthName(b.dateTime)} u ${formatTime(b.dateTime)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    heroText,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.shopDetails,
                    arguments: shop,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            b.shopImageUrl,
                            width: 58,
                            height: 58,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 58,
                              height: 58,
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
                                b.category.name.toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                b.shopName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                b.shopAddress,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row(b.category.icon, 'Usluga', b.serviceName),
                    _row(
                      Icons.access_time,
                      'Trajanje',
                      '${b.durationMinutes} minuta',
                    ),
                    _row(
                      Icons.payments_outlined,
                      'Cena (plaća se u radnji)',
                      formatPrice(b.price),
                    ),
                    _row(
                      Icons.confirmation_number_outlined,
                      'Broj rezervacije',
                      b.code,
                    ),
                    if (b.note.isNotEmpty)
                      _row(Icons.notes, 'Napomena', b.note, last: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (b.isActive) ...[
                PrimaryButton(
                  label: 'Kopiraj detalje',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _copy(context, b),
                ),
                const SizedBox(height: 9),
                PrimaryButton(
                  label: 'Otkaži termin',
                  variant: AppButtonVariant.danger,
                  onPressed: () => _cancel(context, b),
                ),
              ],
              if (b.status == BookingStatus.completed) ...[
                if (!ReviewStore.instance.isBookingReviewed(b.id))
                  PrimaryButton(
                    label: 'Oceni radnju',
                    icon: Icons.star_border,
                    onPressed: () =>
                        showReviewSheet(context, shop: shop, bookingId: b.id),
                  ),
                if (!ReviewStore.instance.isBookingReviewed(b.id))
                  const SizedBox(height: 9),
                PrimaryButton(
                  label: 'Zakaži ponovo',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.booking,
                    arguments: shop,
                  ),
                ),
              ],
              if (b.status == BookingStatus.cancelled)
                PrimaryButton(
                  label: 'Zakaži ponovo',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.booking,
                    arguments: shop,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _row(IconData icon, String label, String value, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
