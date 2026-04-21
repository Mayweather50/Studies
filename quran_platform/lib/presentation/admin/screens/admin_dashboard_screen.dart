import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/loading_widget.dart';
import '../bloc/admin_bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(const AdminLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Панель управления')),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const LoadingWidget();
          if (state is AdminError) {
            return ErrorWidget2(
              message: state.message,
              onRetry: () =>
                  context.read<AdminBloc>().add(const AdminLoadRequested()),
            );
          }
          if (state is AdminLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<AdminBloc>().add(const AdminLoadRequested()),
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                children: [
                  Text('Статистика', style: AppTextStyles.heading3),
                  const SizedBox(height: AppTheme.spacingM),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: AppTheme.spacingM,
                    crossAxisSpacing: AppTheme.spacingM,
                    childAspectRatio: 1.3,
                    children: [
                      _StatCard(
                        icon: Icons.school_rounded,
                        label: 'Учителя',
                        value: '${state.teachers.length}',
                        color: AppColors.primary,
                      ),
                      _StatCard(
                        icon: Icons.people_rounded,
                        label: 'Ученики',
                        value: '${state.totalStudents}',
                        color: AppColors.info,
                      ),
                      _StatCard(
                        icon: Icons.calendar_month_rounded,
                        label: 'Всего уроков',
                        value: '${state.totalLessons}',
                        color: AppColors.secondary,
                      ),
                      _StatCard(
                        icon: Icons.pending_actions_rounded,
                        label: 'Активных',
                        value:
                            '${state.bookings.where((b) => b.isPending || b.isConfirmed).length}',
                        color: AppColors.success,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),
                  Text('Последние записи', style: AppTextStyles.heading3),
                  const SizedBox(height: AppTheme.spacingM),
                  ...state.bookings.take(10).map((b) => Container(
                        margin:
                            const EdgeInsets.only(bottom: AppTheme.spacingS),
                        padding: const EdgeInsets.all(AppTheme.spacingM),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLarge),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${b.studentName} → ${b.teacherName}',
                                    style: AppTextStyles.labelSmall,
                                  ),
                                  Text(
                                    '${b.discipline} • ${b.timeSlot}',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            _statusBadge(b.status),
                          ],
                        ),
                      )),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'pending':
        color = AppColors.warning;
        text = 'Ожидает';
      case 'confirmed':
        color = AppColors.success;
        text = 'Принят';
      case 'cancelled':
        color = AppColors.error;
        text = 'Отменён';
      default:
        color = AppColors.textSecondary;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppTheme.spacingS),
          Text(value,
              style: AppTextStyles.heading2.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
