import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/category_ui.dart';
import '../core/utils/formatters.dart';
import '../models/service_item.dart';
import '../models/shop.dart';
import '../navigation/app_routes.dart';
import '../services/booking_store.dart';
import '../services/owner_store.dart';
import '../widgets/primary_button.dart';
import '../widgets/time_slot_chip.dart';

class BookingScreen extends StatefulWidget {
  final Shop shop;
  const BookingScreen({super.key, required this.shop});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0; // 0 usluga, 1 datum, 2 vreme, 3 pregled
  late final List<ServiceItem> _services;
  ServiceItem? _service;
  late DateTime _month;
  DateTime? _date;
  DateTime? _time;
  final _note = TextEditingController();

  @override
  void initState() {
    super.initState();
    _services = OwnerStore.instance.servicesFor(widget.shop.id);
    _service = _services.isNotEmpty ? _services.first : null;
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _back() {
    if (_step == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _step--);
    }
  }

  void _next() => setState(() => _step++);

  void _confirm() {
    final booking = BookingStore.instance.create(
      shop: widget.shop,
      service: _service!,
      dateTime: _time!,
      note: _note.text.trim(),
    );
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.bookingConfirmation,
      arguments: booking,
    );
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        return _service != null;
      case 1:
        return _date != null;
      case 2:
        return _time != null;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _step--);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Zakaži termin'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _back,
          ),
        ),
        bottomNavigationBar: _footer(),
        body: Column(
          children: [
            _progress(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  switch (_step) {
                    0 => _stepService(),
                    1 => _stepDate(),
                    2 => _stepTime(),
                    _ => _stepReview(),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (_step + 1) / 5,
              minHeight: 3,
              color: AppColors.accent,
              backgroundColor: const Color(0xFFDDDEDA),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Korak ${_step + 1} od 5',
              style: const TextStyle(
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String? eyebrow, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null)
          Text(
            eyebrow,
            style: const TextStyle(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 1.4,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 22),
      ],
    );
  }

  // ---------- Korak 1: usluga ----------
  Widget _stepService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          widget.shop.name.toUpperCase(),
          'Izaberi uslugu',
          'Možeš izabrati jednu uslugu po terminu.',
        ),
        if (_services.isEmpty)
          const Text(
            'Ova radnja trenutno nema aktivnih usluga.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        for (final s in _services)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ServiceTile(
              service: s,
              selected: _service?.id == s.id,
              onTap: () => setState(() {
                _service = s;
                _time = null; // trajanje se menja, vreme se bira ponovo
              }),
            ),
          ),
      ],
    );
  }

  // ---------- Korak 2: datum ----------
  Widget _stepDate() {
    final today = dateOnly(DateTime.now());
    final last = today.add(const Duration(days: 60));
    final first = DateTime(_month.year, _month.month, 1);
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final blanks = first.weekday - 1;
    final canPrev = first.isAfter(DateTime(today.year, today.month, 1));
    final canNext = !DateTime(_month.year, _month.month + 1, 1).isAfter(last);

    final cells = <Widget>[
      for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++)
        _dayCell(DateTime(_month.year, _month.month, d), today, last),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          null,
          'Izaberi datum',
          'Dani kada radnja ne radi ili su prošli prikazani su sivo.',
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: canPrev
                        ? () => setState(
                            () => _month = DateTime(
                              _month.year,
                              _month.month - 1,
                            ),
                          )
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text(
                    '${monthNameCap(_month)} ${_month.year}.',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    onPressed: canNext
                        ? () => setState(
                            () => _month = DateTime(
                              _month.year,
                              _month.month + 1,
                            ),
                          )
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final d in const [
                    'Pon',
                    'Uto',
                    'Sre',
                    'Čet',
                    'Pet',
                    'Sub',
                    'Ned',
                  ])
                    Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.1,
                children: cells,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dayCell(DateTime day, DateTime today, DateTime last) {
    final enabled =
        !day.isBefore(today) &&
        !day.isAfter(last) &&
        BookingStore.instance.isDayBookable(widget.shop.id, day);
    final selected = _date != null && isSameDay(_date!, day);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled
            ? () => setState(() {
                _date = day;
                _time = null;
              })
            : null,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColors.primary : null,
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: enabled ? FontWeight.w600 : FontWeight.w400,
              color: selected
                  ? Colors.white
                  : enabled
                  ? AppColors.primary
                  : const Color(0xFFC8CCCF),
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Korak 3: vreme ----------
  Widget _stepTime() {
    final slots = BookingStore.instance.slotsFor(
      widget.shop,
      _service!,
      _date!,
    );
    final morning = slots.where((s) => s.time.hour < 12).toList();
    final afternoon = slots.where((s) => s.time.hour >= 12).toList();
    final anyFree = slots.any((s) => s.available);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          null,
          'Izaberi vreme',
          '${weekdayName(_date!)}, ${_date!.day}. ${monthName(_date!)} · '
              'Trajanje ${_service!.durationMinutes} min',
        ),
        if (!anyFree)
          const Text(
            'Nema slobodnih termina za izabrani dan. Probaj drugi datum.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        _slotSection('Pre podne', morning),
        _slotSection('Posle podne', afternoon),
      ],
    );
  }

  Widget _slotSection(String title, List<TimeSlot> slots) {
    if (slots.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 11),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 9,
            crossAxisSpacing: 9,
            childAspectRatio: 2.4,
            children: [
              for (final s in slots)
                TimeSlotChip(
                  label: formatTime(s.time),
                  selected: _time == s.time,
                  enabled: s.available,
                  onTap: () => setState(() => _time = s.time),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Korak 4: pregled ----------
  Widget _stepReview() {
    final shop = widget.shop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          null,
          'Pregled rezervacije',
          'Proveri detalje pre potvrde termina.',
        ),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  shop.imageUrl,
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
                      shop.category.singular.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shop.address,
                      style: const TextStyle(
                        fontSize: 9,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _summaryRow(shop.category.icon, 'Usluga', _service!.name, 0),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _summaryRow(
                Icons.calendar_month_outlined,
                'Datum',
                formatDateLong(_date!),
                1,
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _summaryRow(
                Icons.access_time,
                'Vreme',
                '${formatTime(_time!)} · ${_service!.durationMinutes} min',
                2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Napomena za majstora (opciono)',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _note,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Dodaj posebnu napomenu...',
          ),
        ),
        const SizedBox(height: 18),
        const Divider(color: Color(0xFFDFE0DD)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ukupno za plaćanje u radnji',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              formatPrice(_service!.price),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String label, String value, int goToStep) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
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
          GestureDetector(
            onTap: () => setState(() => _step = goToStep),
            child: const Text(
              'Izmeni',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Donja traka ----------
  Widget _footer() {
    String? label;
    String? value;
    switch (_step) {
      case 0:
        label = 'Ukupno';
        value = _service == null ? '-' : formatPrice(_service!.price);
        break;
      case 1:
        label = 'Izabrani datum';
        value = _date == null ? '-' : formatDateShort(_date!);
        break;
      case 2:
        label = 'Izabrano vreme';
        value = _time == null ? '-' : formatTime(_time!);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
          child: _step == 3
              ? PrimaryButton(label: 'Potvrdi termin', onPressed: _confirm)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label!,
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          value!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    PrimaryButton(
                      label: 'Nastavi',
                      icon: Icons.arrow_forward,
                      expand: false,
                      onPressed: _canContinue ? _next : null,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceItem service;
  final bool selected;
  final VoidCallback onTap;
  const _ServiceTile({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: selected ? AppColors.secondary : Colors.transparent,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? AppColors.secondary : const Color(0xFFAAB4BC),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${service.durationMinutes} min',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                formatPrice(service.price),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
