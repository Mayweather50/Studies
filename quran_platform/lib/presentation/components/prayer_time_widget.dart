import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_theme.dart';
import '../../domain/entities/prayer_time_entity.dart';
import 'glass_card.dart';

class PrayerTimeWidget extends StatelessWidget {
  final PrayerTimeEntity? prayerTimes;

  const PrayerTimeWidget({super.key, this.prayerTimes});

  @override
  Widget build(BuildContext context) {
    if (prayerTimes == null) {
      return const SizedBox.shrink();
    }

    final times = prayerTimes!.toMap();

    return GlassCard(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mosque_rounded,
                color: AppColors.secondary,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Время намаза',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: times.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppTheme.spacingM),
              itemBuilder: (context, index) {
                final entry = times.entries.elementAt(index);
                return _PrayerTimeItem(
                  name: entry.key,
                  time: entry.value,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerTimeItem extends StatelessWidget {
  final String name;
  final String time;

  const _PrayerTimeItem({required this.name, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
