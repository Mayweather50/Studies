import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/booking_card.dart';
import '../../components/loading_widget.dart';
import '../bloc/admin_bloc.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Все записи'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Ожидают'),
            Tab(text: 'Приняты'),
            Tab(text: 'Отменены'),
          ],
        ),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const LoadingWidget();
          if (state is AdminLoaded) {
            final all = state.bookings;
            final pending = all.where((b) => b.isPending).toList();
            final confirmed = all.where((b) => b.isConfirmed).toList();
            final cancelled = all.where((b) => b.isCancelled).toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildList(all, 'Нет записей'),
                _buildList(pending, 'Нет ожидающих'),
                _buildList(confirmed, 'Нет принятых'),
                _buildList(cancelled, 'Нет отменённых'),
              ],
            );
          }
          return const SizedBox.shrink();
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

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingCard(booking: bookings[index]);
      },
    );
  }
}
