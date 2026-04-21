import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/glass_card.dart';
import '../bloc/auth_bloc.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Прогресс')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.school_rounded,
                    label: 'Уроков',
                    value: '12',
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_rounded,
                    label: 'Уровень',
                    value: 'Базовый',
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.timer_rounded,
                    label: 'Часов',
                    value: '9',
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _StatCard(
                    icon: Icons.auto_stories_rounded,
                    label: 'Сур',
                    value: '5',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spacingXL),
            Text('Изученные суры', style: AppTextStyles.heading3),
            const SizedBox(height: AppTheme.spacingM),

            ..._sampleSuras.map((sura) => Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          sura.number.toString(),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sura.name,
                                style: AppTextStyles.labelMedium),
                            Text(sura.arabicName,
                                style: AppTextStyles.caption),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: AppTheme.spacingS),
          Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _SuraSample {
  final int number;
  final String name;
  final String arabicName;

  const _SuraSample(this.number, this.name, this.arabicName);
}

const _sampleSuras = [
  _SuraSample(1, 'Аль-Фатиха', 'الفاتحة'),
  _SuraSample(112, 'Аль-Ихлас', 'الإخلاص'),
  _SuraSample(113, 'Аль-Фалак', 'الفلق'),
  _SuraSample(114, 'Ан-Нас', 'الناس'),
  _SuraSample(111, 'Аль-Масад', 'المسد'),
];
