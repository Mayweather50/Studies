import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_theme.dart';

class SlotGrid extends StatelessWidget {
  final List<String> availableSlots;
  final List<String> bookedSlots;
  final String? selectedSlot;
  final ValueChanged<String>? onSlotSelected;

  const SlotGrid({
    super.key,
    required this.availableSlots,
    this.bookedSlots = const [],
    this.selectedSlot,
    this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (availableSlots.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Text(
            'Нет доступных слотов на выбранную дату',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.2,
      ),
      itemCount: availableSlots.length,
      itemBuilder: (context, index) {
        final slot = availableSlots[index];
        final isBooked = bookedSlots.contains(slot);
        final isSelected = slot == selectedSlot;

        return GestureDetector(
          onTap: isBooked ? null : () => onSlotSelected?.call(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isBooked
                  ? AppColors.divider
                  : isSelected
                      ? AppColors.primary
                      : AppColors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : isBooked
                        ? AppColors.divider
                        : AppColors.divider,
                width: isSelected ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: AppTextStyles.labelSmall.copyWith(
                color: isBooked
                    ? AppColors.textSecondary
                    : isSelected
                        ? AppColors.textLight
                        : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                decoration:
                    isBooked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
