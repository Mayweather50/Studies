import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/booking_card.dart';
import '../../components/loading_widget.dart';
import '../../student/bloc/auth_bloc.dart';
import '../bloc/teacher_dashboard_bloc.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context
          .read<TeacherDashboardBloc>()
          .add(TeacherDashboardLoadRequested(authState.user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Панель учителя')),
      body: BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
        builder: (context, state) {
          if (state is TeacherDashboardLoading) {
            return const LoadingWidget();
          }
          if (state is TeacherDashboardError) {
            return ErrorWidget2(message: state.message, onRetry: _load);
          }
          if (state is TeacherDashboardLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _load(),
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.pending_actions_rounded,
                          label: 'Ожидают',
                          value: '${state.pendingBookings.length}',
                          color: AppColors.warning,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.event_available_rounded,
                          label: 'Ближайшие',
                          value: '${state.upcomingBookings.length}',
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppTheme.spacingXL),
                  if (state.pendingBookings.isNotEmpty) ...[
                    Text('Новые запросы', style: AppTextStyles.heading3),
                    const SizedBox(height: AppTheme.spacingM),
                    ...state.pendingBookings.take(5).map(
                          (b) => BookingCard(
                            booking: b,
                            showTeacherName: false,
                          ),
                        ),
                  ],

                  const SizedBox(height: AppTheme.spacingL),
                  if (state.upcomingBookings.isNotEmpty) ...[
                    Text('Ближайшие уроки', style: AppTextStyles.heading3),
                    const SizedBox(height: AppTheme.spacingM),
                    ...state.upcomingBookings.take(5).map(
                          (b) => BookingCard(
                            booking: b,
                            showTeacherName: false,
                          ),
                        ),
                  ],

                  if (state.pendingBookings.isEmpty &&
                      state.upcomingBookings.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: AppTheme.spacingXXL),
                      child: EmptyWidget(
                        message: 'Нет записей',
                        icon: Icons.event_busy_rounded,
                      ),
                    ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
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
