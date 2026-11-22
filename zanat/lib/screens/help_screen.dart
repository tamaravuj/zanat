import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faq = [
    (
      'Kako da zakažem termin?',
      'Izaberi radnju, dodirni "Zakaži termin", pa izaberi uslugu, datum i slobodno vreme. Na kraju potvrdi rezervaciju.',
    ),
    (
      'Kako da otkažem termin?',
      'U sekciji Moji termini otvori termin i dodirni "Otkaži termin".',
    ),
    (
      'Kako se plaća usluga?',
      'Usluga se plaća direktno u radnji nakon završetka posla.',
    ),
    (
      'Kako da ocenim radnju?',
      'Kada se termin završi, u njegovim detaljima pojaviće se dugme "Oceni radnju".',
    ),
    (
      'Kako da dodam radnju u omiljene?',
      'Dodirni srce na kartici radnje ili na njenoj naslovnoj slici.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomoć i podrška')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          const Text(
            'Česta pitanja',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final q in _faq)
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        q.$1,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.$2,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.55,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEDF1F4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.mail_outline, color: AppColors.secondary),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Nisi našao/la odgovor? Piši nam na podrska@zanat.rs',
                    style: TextStyle(fontSize: 12),
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
