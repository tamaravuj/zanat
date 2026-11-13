import 'package:flutter/material.dart';

import '../../widgets/app_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO(commit 16): AuthService.sendPasswordReset(email)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link za novu lozinku je poslat.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      eyebrow: 'OPORAVAK NALOGA',
      title: 'Zaboravljena lozinka',
      subtitle: 'Unesi e-mail i poslaćemo ti link za novu lozinku.',
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
            const SizedBox(height: 25),
            PrimaryButton(
              label: 'Pošalji link',
              icon: Icons.arrow_forward,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
