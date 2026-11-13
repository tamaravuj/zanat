import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../navigation/app_routes.dart';
import '../../services/mock_data.dart';
import '../../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 410,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(36),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      MockData.imgTailor,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: AppColors.secondary),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.primary.withValues(alpha: 0.08),
                            AppColors.primary.withValues(alpha: 0.22),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: top + 24,
                      right: 17,
                      child: _FloatingCard(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDF2F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.place_outlined,
                              size: 20,
                              color: AppColors.secondary,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const _CardText('12 radnji', 'u tvojoj blizini'),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 28,
                      left: 17,
                      child: _FloatingCard(
                        children: [
                          const CircleAvatar(
                            radius: 17,
                            backgroundColor: Color(0xFFE6EDF3),
                            child: Text(
                              'MP',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          const _CardText('Termin potvrđen', 'Danas u 16:30'),
                          const SizedBox(width: 14),
                          const Icon(
                            Icons.check,
                            size: 18,
                            color: AppColors.success,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '01 / 03',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lokalni majstori, na jednom mestu.',
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.9,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Pronađi proverene zanatlije, uporedi cene i zakaži termin za manje od minuta.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        for (var i = 0; i < 2; i++) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC5CBD0),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Započni',
                      icon: Icons.arrow_forward,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.login),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.shell,
                        ),
                        child: const Text(
                          'Preskoči',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingCard extends StatelessWidget {
  final List<Widget> children;
  const _FloatingCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class _CardText extends StatelessWidget {
  final String title;
  final String subtitle;
  const _CardText(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
