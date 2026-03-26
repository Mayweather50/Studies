import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/date_utils.dart';
import '../../components/loading_widget.dart';
import '../../components/slot_grid.dart';
import '../../student/bloc/auth_bloc.dart';
import '../bloc/teacher_dashboard_bloc.dart';

class TeacherScheduleScreen extends StatefulWidget {
  const TeacherScheduleScreen({super.key});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Расписание')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 90)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDate = selected;
                _focusedDay = focused;
              });
            },
            locale: 'ru_RU',
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            child: Row(
              children: [
                Text(
                  AppDateUtils.formatDayMonth(_selectedDate),
                  style: AppTextStyles.labelLarge,
                ),
                if (_selectedDate.weekday == DateTime.friday) ...[
                  const SizedBox(width: AppTheme.spacingS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      'Джума 12:00-14:30',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              child: BlocBuilder<TeacherDashboardBloc,
                  TeacherDashboardState>(
                builder: (context, state) {
                  final slots =
                      AppDateUtils.generateTimeSlots(_selectedDate);
                  List<String> bookedSlots = [];

                  if (state is TeacherDashboardLoaded) {
                    bookedSlots = state.bookings
                        .where((b) =>
                            isSameDay(b.date, _selectedDate) &&
                            (b.isConfirmed || b.isPending))
                        .map((b) => b.timeSlot)
                        .toList();
                  }

                  return SlotGrid(
                    availableSlots: slots,
                    bookedSlots: bookedSlots,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
