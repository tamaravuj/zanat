import 'package:flutter/material.dart';

import '../services/mock_data.dart';
import '../services/review_store.dart';
import '../services/user_store.dart';
import '../widgets/empty_state.dart';
import '../widgets/review_card.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moje recenzije')),
      body: ListenableBuilder(
        listenable: ReviewStore.instance,
        builder: (context, _) {
          final mine = ReviewStore.instance.byUser(UserStore.uid);
          if (mine.isEmpty) {
            return const EmptyState(
              icon: Icons.star_border,
              title: 'Još nemaš recenzija',
              message: 'Oceni radnju nakon završenog termina.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemCount: mine.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              final r = mine[i];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 6),
                    child: Text(
                      MockData.shopById(r.shopId).name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  ReviewCard(review: r),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
