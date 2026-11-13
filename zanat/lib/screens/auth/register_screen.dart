import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(commit 16): AuthService.register(...)
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'NOVI NALOG',
      title: 'Kreiraj nalog',
      subtitle: 'Unesi podatke i pronađi svog majstora.',
      footer: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Već imaš nalog?',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Prijavi se',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
      child: Form(
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
            AppTextField(
              label: 'E-mail adresa',
              hint: 'ana@email.com',
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@'))
                  ? 'Unesi ispravan e-mail'
                  : null,
            ),
            const SizedBox(height: 17),
            AppTextField(
              label: 'Broj telefona',
              hint: '+381 64 123 4567',
              controller: _phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 17),
            AppTextField(
              label: 'Lozinka',
              hint: 'Najmanje 8 karaktera',
              controller: _password,
              obscure: true,
              validator: (v) => (v == null || v.length < 8)
                  ? 'Lozinka mora imati najmanje 8 karaktera'
                  : null,
            ),
            const SizedBox(height: 25),
            PrimaryButton(
              label: 'Kreiraj nalog',
              icon: Icons.arrow_forward,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
