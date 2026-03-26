import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class RatingView extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;
  final int maxStars;

  const RatingView({
    super.key,
    required this.rating,
    this.size = 16,
    this.showValue = true,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxStars, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star_rounded,
                color: AppColors.secondary, size: size);
          } else if (index < rating.ceil() && rating % 1 != 0) {
            return Icon(Icons.star_half_rounded,
                color: AppColors.secondary, size: size);
          } else {
            return Icon(Icons.star_outline_rounded,
                color: AppColors.secondary.withValues(alpha: 0.3), size: size);
          }
        }),
        if (showValue) ...[
          SizedBox(width: size * 0.25),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.75,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
