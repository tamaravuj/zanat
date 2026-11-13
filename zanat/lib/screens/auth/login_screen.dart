import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../navigation/app_routes.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(commit 16): AuthService.signIn(email, password)
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.shell, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'DOBRODOŠLI NAZAD',
      title: 'Prijavi se',
      subtitle: 'Nastavi tamo gde si stao/la.',
      footer: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Nemaš nalog?',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text(
              'Registruj se',
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
              label: 'Lozinka',
              hint: 'Najmanje 8 karaktera',
              controller: _password,
              obscure: true,
              validator: (v) => (v == null || v.length < 8)
                  ? 'Lozinka mora imati najmanje 8 karaktera'
                  : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.forgotPassword),
                child: const Text(
                  'Zaboravili ste lozinku?',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Prijavi se',
              icon: Icons.arrow_forward,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
