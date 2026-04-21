import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/booking_card.dart';
import '../../components/loading_widget.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/booking_bloc.dart';

class MyLessonsScreen extends StatefulWidget {
  const MyLessonsScreen({super.key});

  @override
  State<MyLessonsScreen> createState() => _MyLessonsScreenState();
}

class _MyLessonsScreenState extends State<MyLessonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadBookings();
  }

  void _loadBookings() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<BookingBloc>().add(
            BookingStudentLoadRequested(authState.user.id),
          );
    }
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
        title: const Text('Мои уроки'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Предстоящие'),
            Tab(text: 'Прошедшие'),
          ],
        ),
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const LoadingWidget();
          }
          if (state is BookingsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildList(state.upcoming, 'Нет предстоящих уроков'),
                _buildList(state.past, 'Нет прошедших уроков'),
              ],
            );
          }
          if (state is BookingError) {
            return ErrorWidget2(
              message: state.message,
              onRetry: _loadBookings,
            );
          }
          return const EmptyWidget(
            message: 'Нет уроков',
            icon: Icons.calendar_today_rounded,
          );
        },
      ),
    );
  }

  Widget _buildList(List bookings, String emptyMessage) {
    if (bookings.isEmpty) {
      return EmptyWidget(
        message: emptyMessage,
        icon: Icons.event_busy_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _loadBookings(),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return BookingCard(
            booking: booking,
            onTap: () => context.push('/student/lesson/${booking.id}'),
          );
        },
      ),
    );
  }
}
