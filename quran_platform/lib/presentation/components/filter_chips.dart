import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/theme/app_theme.dart';

class FilterChipRow extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?> onSelected;
  final String label;

  const FilterChipRow({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.spacingM),
          child: Text(label, style: AppTextStyles.labelSmall),
        ),
        const SizedBox(height: AppTheme.spacingS),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = item == selectedItem;

              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingS),
                child: FilterChip(
                  label: Text(item),
                  selected: isSelected,
                  onSelected: (_) {
                    onSelected(isSelected ? null : item);
                  },
                  selectedColor:
                      AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                  labelStyle: AppTextStyles.caption.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.divider,
                  ),
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
