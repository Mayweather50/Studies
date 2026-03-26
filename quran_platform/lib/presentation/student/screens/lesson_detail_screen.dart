import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../components/custom_button.dart';
import '../bloc/booking_bloc.dart';

class LessonDetailScreen extends StatelessWidget {
  final BookingEntity booking;

  const LessonDetailScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Детали урока')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            Center(child: _buildStatusBadge()),
            const SizedBox(height: AppTheme.spacingXL),

            _infoTile(Icons.person_rounded, 'Учитель', booking.teacherName),
            _infoTile(Icons.book_rounded, 'Дисциплина', booking.discipline),
            _infoTile(Icons.calendar_today_rounded, 'Дата',
                AppDateUtils.formatDate(booking.date)),
            _infoTile(Icons.access_time_rounded, 'Время', booking.timeSlot),

            const Spacer(),

            // Zoom button
            if (booking.zoomLink != null && booking.zoomLink!.isNotEmpty) ...[
              CustomButton(
                text: 'Открыть Zoom',
                icon: Icons.videocam_rounded,
                backgroundColor: AppColors.info,
                onPressed: () async {
                  final uri = Uri.parse(booking.zoomLink!);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacingM),
            ],

            // Cancel
            if (booking.isPending) ...[
              BlocBuilder<BookingBloc, BookingState>(
                builder: (context, state) {
                  return CustomButton(
                    text: 'Отменить запись',
                    isOutlined: true,
                    backgroundColor: AppColors.error,
                    textColor: AppColors.error,
                    isLoading: state is BookingLoading,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Отменить запись?'),
                          content: const Text(
                              'Вы уверены, что хотите отменить запись?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Нет'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.read<BookingBloc>().add(
                                      BookingStatusUpdateRequested(
                                        bookingId: booking.id,
                                        status: AppConstants.statusCancelled,
                                      ),
                                    );
                              },
                              child: const Text('Да, отменить',
                                  style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    switch (booking.status) {
      case 'pending':
        color = AppColors.warning;
        text = 'Ожидает подтверждения';
      case 'confirmed':
        color = AppColors.success;
        text = 'Подтверждён';
      case 'cancelled':
        color = AppColors.error;
        text = 'Отменён';
      case 'completed':
        color = AppColors.info;
        text = 'Завершён';
      default:
        color = AppColors.textSecondary;
        text = booking.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: color),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppTheme.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(value, style: AppTextStyles.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
