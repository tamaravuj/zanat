import 'package:flutter/material.dart';

import '../services/user_store.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: UserStore.instance.fullName);
  final _phone = TextEditingController(text: UserStore.instance.phone);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    UserStore.instance.updateProfile(
      fullName: _name.text.trim(),
      phone: _phone.text.trim(),
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profil je sačuvan.')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lični podaci')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'Ime i prezime',
                  hint: 'Ana Jovanović',
                  controller: _name,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Unesi ime i prezime'
                      : null,
                ),
                const SizedBox(height: 17),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'E-mail adresa',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: UserStore.instance.email,
                      enabled: false,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                AppTextField(
                  label: 'Broj telefona',
                  hint: '+381 64 123 4567',
                  controller: _phone,
                  keyboardType: TextInputType.phone,
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
