import 'package:flutter/material.dart';

import '../../services/owner_store.dart';
import '../../widgets/primary_button.dart';

class OwnerInfoScreen extends StatefulWidget {
  const OwnerInfoScreen({super.key});

  @override
  State<OwnerInfoScreen> createState() => _OwnerInfoScreenState();
}

class _OwnerInfoScreenState extends State<OwnerInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: OwnerStore.instance.shopName);
  final _desc = TextEditingController(text: OwnerStore.instance.description);
  final _address = TextEditingController(text: OwnerStore.instance.address);

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _address.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    OwnerStore.instance.updateInfo(
      name: _name.text.trim(),
      description: _desc.text.trim(),
      address: _address.text.trim(),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Podaci su sačuvani.')));
    Navigator.pop(context);
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Polje je obavezno' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Osnovni podaci')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  validator: _required,
                  decoration: const InputDecoration(labelText: 'Naziv radnje'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _address,
                  validator: _required,
                  decoration: const InputDecoration(labelText: 'Adresa'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _desc,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Opis radnje'),
                ),
                const SizedBox(height: 25),
                PrimaryButton(label: 'Sačuvaj izmene', onPressed: _save),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
