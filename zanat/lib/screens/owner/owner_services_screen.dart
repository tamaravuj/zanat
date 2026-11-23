import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../models/service_item.dart';
import '../../services/owner_store.dart';
import '../../widgets/empty_state.dart';

class OwnerServicesScreen extends StatelessWidget {
  const OwnerServicesScreen({super.key});

  Future<void> _edit(BuildContext context, {ServiceItem? existing}) async {
    final result = await showDialog<ServiceItem>(
      context: context,
      builder: (_) => _ServiceDialog(existing: existing),
    );
    if (result == null) return;
    if (existing == null) {
      OwnerStore.instance.addService(
        result.name,
        result.price,
        result.durationMinutes,
      );
    } else {
      OwnerStore.instance.updateService(result);
    }
  }

  Future<void> _delete(BuildContext context, ServiceItem s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ukloniti uslugu?'),
        content: Text(s.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Otkaži'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Ukloni',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok == true) OwnerStore.instance.removeService(s.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usluge i cene'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _edit(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: OwnerStore.instance,
        builder: (context, _) {
          final services = OwnerStore.instance.services;
          if (services.isEmpty) {
            return EmptyState(
              icon: Icons.content_cut,
              title: 'Nema usluga',
              message: 'Dodaj prvu uslugu da bi klijenti mogli da zakazuju.',
              actionLabel: 'Dodaj uslugu',
              onAction: () => _edit(context),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              const Text(
                'Aktivne usluge',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Uredi ponudu, trajanje i cene usluga.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              for (final s in services)
                Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.name,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${s.durationMinutes} min · ${formatPrice(s.price)}',
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 20,
                          color: AppColors.secondary,
                        ),
                        onPressed: () => _edit(context, existing: s),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: AppColors.error,
                        ),
                        onPressed: () => _delete(context, s),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              OutlinedButton.icon(
                onPressed: () => _edit(context),
                icon: const Icon(Icons.add),
                label: const Text('Dodaj novu uslugu'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ServiceDialog extends StatefulWidget {
  final ServiceItem? existing;
  const _ServiceDialog({this.existing});

  @override
  State<_ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<_ServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _price = TextEditingController(
    text: widget.existing?.price.toString() ?? '',
  );
  late final _minutes = TextEditingController(
    text: widget.existing?.durationMinutes.toString() ?? '30',
  );

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _minutes.dispose();
    super.dispose();
  }

  String? _positiveInt(String? v) {
    final n = int.tryParse((v ?? '').trim());
    return (n == null || n <= 0) ? 'Unesi broj veći od 0' : null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ServiceItem(
        id: widget.existing?.id ?? '',
        shopId: OwnerStore.ownerShopId,
        name: _name.text.trim(),
        price: int.parse(_price.text.trim()),
        durationMinutes: int.parse(_minutes.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existing == null ? 'Nova usluga' : 'Izmeni uslugu'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Unesi naziv' : null,
              decoration: const InputDecoration(labelText: 'Naziv usluge'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              validator: _positiveInt,
              decoration: const InputDecoration(labelText: 'Cena (RSD)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _minutes,
              keyboardType: TextInputType.number,
              validator: _positiveInt,
              decoration: const InputDecoration(labelText: 'Trajanje (min)'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Otkaži'),
        ),
        TextButton(onPressed: _save, child: const Text('Sačuvaj')),
      ],
    );
  }
}
