import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../components/custom_button.dart';
import '../../components/loading_widget.dart';
import '../../student/bloc/auth_bloc.dart';
import '../bloc/teacher_dashboard_bloc.dart';

class TeacherBookingsScreen extends StatefulWidget {
  const TeacherBookingsScreen({super.key});

  @override
  State<TeacherBookingsScreen> createState() => _TeacherBookingsScreenState();
}

class _TeacherBookingsScreenState extends State<TeacherBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

  String get _teacherId {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) return authState.user.id;
    return '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Записи'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Ожидают'),
            Tab(text: 'Ближайшие'),
            Tab(text: 'Прошедшие'),
          ],
        ),
      ),
      body: BlocBuilder<TeacherDashboardBloc, TeacherDashboardState>(
        builder: (context, state) {
          if (state is TeacherDashboardLoading) {
            return const LoadingWidget();
          }
          if (state is TeacherDashboardError) {
            return ErrorWidget2(message: state.message, onRetry: _load);
          }
          if (state is TeacherDashboardLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildPendingList(state),
                _buildBookingList(state.upcomingBookings, 'Нет ближайших уроков'),
                _buildBookingList(state.pastBookings, 'Нет прошедших уроков'),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPendingList(TeacherDashboardLoaded state) {
    if (state.pendingBookings.isEmpty) {
      return const EmptyWidget(
        message: 'Нет новых запросов',
        icon: Icons.inbox_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: state.pendingBookings.length,
      itemBuilder: (context, index) {
        final booking = state.pendingBookings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(booking.studentName, style: AppTextStyles.labelLarge),
              const SizedBox(height: 4),
              Text(
                '${booking.discipline} • ${AppDateUtils.formatDate(booking.date)} • ${booking.timeSlot}',
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: AppTheme.spacingM),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Принять',
                      height: 40,
                      onPressed: () => _showZoomDialog(booking.id),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: CustomButton(
                      text: 'Отклонить',
                      height: 40,
                      isOutlined: true,
                      backgroundColor: AppColors.error,
                      textColor: AppColors.error,
                      onPressed: () {
                        context.read<TeacherDashboardBloc>().add(
                              TeacherBookingActionRequested(
                                bookingId: booking.id,
                                status: AppConstants.statusCancelled,
                                teacherId: _teacherId,
                              ),
                            );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showZoomDialog(String bookingId) {
    final zoomController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zoom-ссылка'),
        content: TextField(
          controller: zoomController,
          decoration: const InputDecoration(
            hintText: 'https://zoom.us/j/...',
            labelText: 'Вставьте ссылку на Zoom',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<TeacherDashboardBloc>().add(
                    TeacherBookingActionRequested(
                      bookingId: bookingId,
                      status: AppConstants.statusConfirmed,
                      zoomLink: zoomController.text.trim(),
                      teacherId: _teacherId,
                    ),
                  );
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(List bookings, String emptyMessage) {
    if (bookings.isEmpty) {
      return EmptyWidget(
        message: emptyMessage,
        icon: Icons.event_busy_rounded,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.studentName,
                        style: AppTextStyles.labelMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${booking.discipline} • ${AppDateUtils.formatDate(booking.date)} • ${booking.timeSlot}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: booking.isConfirmed
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.textSecondary.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  booking.isConfirmed ? 'Принят' : 'Завершён',
                  style: AppTextStyles.caption.copyWith(
                    color: booking.isConfirmed
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
