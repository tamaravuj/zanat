import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../services/owner_store.dart';

class OwnerHoursScreen extends StatelessWidget {
  const OwnerHoursScreen({super.key});

  Future<void> _editTimes(BuildContext context, DaySchedule d) async {
    final from = await showTimePicker(
      context: context,
      helpText: 'Otvaranje',
      initialTime: TimeOfDay(hour: d.openMin ~/ 60, minute: d.openMin % 60),
    );
    if (from == null || !context.mounted) return;
    final to = await showTimePicker(
      context: context,
      helpText: 'Zatvaranje',
      initialTime: TimeOfDay(hour: d.closeMin ~/ 60, minute: d.closeMin % 60),
    );
    if (to == null || !context.mounted) return;

    final open = from.hour * 60 + from.minute;
    final close = to.hour * 60 + to.minute;
    if (close <= open) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vreme zatvaranja mora biti posle otvaranja.'),
        ),
      );
      return;
    }
    d.openMin = open;
    d.closeMin = close;
    OwnerStore.instance.changed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radno vreme')),
      body: ListenableBuilder(
        listenable: OwnerStore.instance,
        builder: (context, _) {
          final days = OwnerStore.instance.schedule;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Nedeljni raspored',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Podesi kada klijenti mogu da rezervišu termine. Izmene se primenjuju odmah.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < days.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      SizedBox(
                        height: 60,
                        child: Row(
                          children: [
                            Switch(
                              value: days[i].open,
                              activeColor: AppColors.secondary,
                              onChanged: (v) {
                                days[i].open = v;
                                OwnerStore.instance.changed();
                              },
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    days[i].name,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    days[i].open
                                        ? '${formatMinutes(days[i].openMin)} — ${formatMinutes(days[i].closeMin)}'
                                        : 'Zatvoreno',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (days[i].open)
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  size: 20,
                                  color: AppColors.secondary,
                                ),
                                onPressed: () => _editTimes(context, days[i]),
                              ),
                          ],
                        ),
                      ),
                    ],
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
