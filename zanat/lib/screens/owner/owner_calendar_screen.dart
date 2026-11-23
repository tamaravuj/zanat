import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../services/booking_store.dart';
import '../../services/owner_store.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/owner_booking_card.dart';

class OwnerCalendarScreen extends StatefulWidget {
  const OwnerCalendarScreen({super.key});

  @override
  State<OwnerCalendarScreen> createState() => _OwnerCalendarScreenState();
}

class _OwnerCalendarScreenState extends State<OwnerCalendarScreen> {
  late DateTime _weekStart;
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final today = dateOnly(DateTime.now());
    _selected = today;
    _weekStart = today.subtract(Duration(days: today.weekday - 1));
  }

  void _shiftWeek(int weeks) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * weeks));
      _selected = _weekStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekEnd = _weekStart.add(const Duration(days: 6));
    return Scaffold(
      appBar: AppBar(title: const Text('Kalendar')),
      body: ListenableBuilder(
        listenable: BookingStore.instance,
        builder: (context, _) {
          final all = BookingStore.instance
              .forShop(OwnerStore.ownerShopId)
              .where((b) => b.isActive)
              .toList();
          final day =
              all.where((b) => isSameDay(b.dateTime, _selected)).toList()
                ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => _shiftWeek(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      '${_weekStart.day}. ${monthName(_weekStart)} — ${weekEnd.day}. ${monthName(weekEnd)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _shiftWeek(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: Row(
                  children: [
                    for (var i = 0; i < 7; i++)
                      _dayButton(
                        _weekStart.add(Duration(days: i)),
                        all.any(
                          (b) => isSameDay(
                            b.dateTime,
                            _weekStart.add(Duration(days: i)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: day.isEmpty
                    ? const EmptyState(
                        icon: Icons.event_available_outlined,
                        title: 'Nema termina',
                        message: 'Za izabrani dan nema zakazanih termina.',
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: day.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) =>
                            OwnerBookingCard(booking: day[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _dayButton(DateTime d, bool hasBookings) {
    final selected = isSameDay(d, _selected);
    const names = ['PON', 'UTO', 'SRE', 'ČET', 'PET', 'SUB', 'NED'];
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => setState(() => _selected = d),
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  names[d.weekday - 1],
                  style: TextStyle(
                    fontSize: 7,
                    color: selected
                        ? const Color(0xFFCCD5DE)
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${d.day}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasBookings ? AppColors.accent : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
