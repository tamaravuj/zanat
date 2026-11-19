import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/review.dart';
import '../models/shop.dart';
import '../services/review_store.dart';
import '../services/user_store.dart';
import 'primary_button.dart';

Future<void> showReviewSheet(
  BuildContext context, {
  required Shop shop,
  String? bookingId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ReviewSheet(shop: shop, bookingId: bookingId),
  );
}

class _ReviewSheet extends StatefulWidget {
  final Shop shop;
  final String? bookingId;
  const _ReviewSheet({required this.shop, this.bookingId});

  @override
  State<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<_ReviewSheet> {
  int _rating = 5;
  final _comment = TextEditingController();

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  void _submit() {
    ReviewStore.instance.add(
      Review(
        id: 'r${DateTime.now().microsecondsSinceEpoch}',
        shopId: widget.shop.id,
        userId: UserStore.uid,
        userName: UserStore.instance.fullName,
        rating: _rating,
        comment: _comment.text.trim(),
        createdAt: DateTime.now(),
      ),
      bookingId: widget.bookingId,
    );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(const SnackBar(content: Text('Hvala na oceni!')));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Oceni: ${widget.shop.name}',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating ? Icons.star : Icons.star_border,
                    size: 36,
                    color: AppColors.accent,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _comment,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Podeli svoje iskustvo...',
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Pošalji ocenu', onPressed: _submit),
        ],
      ),
    );
  }
}
