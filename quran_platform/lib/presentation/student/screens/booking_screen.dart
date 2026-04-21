import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../components/custom_button.dart';
import '../../components/slot_grid.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/booking_bloc.dart';

class BookingScreen extends StatefulWidget {
  final String teacherId;
  final String teacherName;

  const BookingScreen({
    super.key,
    required this.teacherId,
    required this.teacherName,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _step = 0;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlot;
  String _selectedDiscipline = AppConstants.disciplines.first;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingCreated) {
          context.go('/student/booking-confirmation');
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_stepTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (_step > 0) {
                setState(() => _step--);
              } else {
                context.pop();
              }
            },
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildStep(),
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_step) {
      case 0:
        return 'Выберите дату';
      case 1:
        return 'Выберите время';
      case 2:
        return 'Подтверждение';
      default:
        return 'Запись';
    }
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildDateStep();
      case 1:
        return _buildSlotStep();
      case 2:
        return _buildConfirmStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDateStep() {
    return Column(
      key: const ValueKey(0),
      children: [
        TableCalendar(
          firstDay: DateTime.now(),
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
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: CustomButton(
            text: 'Далее',
            onPressed: () => setState(() => _step = 1),
          ),
        ),
      ],
    );
  }

  Widget _buildSlotStep() {
    final slots = AppDateUtils.generateTimeSlots(_selectedDate);

    return Column(
      key: const ValueKey(1),
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Text(
            AppDateUtils.formatDayMonth(_selectedDate),
            style: AppTextStyles.heading3,
          ),
        ),
        if (_selectedDate.weekday == DateTime.friday)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM),
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingS),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: AppColors.warning, size: 18),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Слоты 12:00-14:30 заблокированы (Джума)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: SlotGrid(
              availableSlots: slots,
              selectedSlot: _selectedSlot,
              onSlotSelected: (slot) =>
                  setState(() => _selectedSlot = slot),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: CustomButton(
            text: 'Далее',
            onPressed:
                _selectedSlot != null ? () => setState(() => _step = 2) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep() {
    return Padding(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Подтвердите запись', style: AppTextStyles.heading3),
          const SizedBox(height: AppTheme.spacingL),

          _infoRow('Учитель', widget.teacherName),
          _infoRow('Дата', AppDateUtils.formatDate(_selectedDate)),
          _infoRow('Время', _selectedSlot ?? ''),

          const SizedBox(height: AppTheme.spacingL),
          Text('Дисциплина', style: AppTextStyles.labelMedium),
          const SizedBox(height: AppTheme.spacingS),
          DropdownButtonFormField<String>(
            value: _selectedDiscipline,
            items: AppConstants.disciplines
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedDiscipline = v);
            },
            decoration: const InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),

          const Spacer(),

          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              return CustomButton(
                text: 'Записаться',
                isLoading: state is BookingLoading,
                onPressed: () {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is AuthAuthenticated) {
                    final booking = BookingEntity(
                      id: '',
                      studentId: authState.user.id,
                      teacherId: widget.teacherId,
                      studentName: authState.user.name,
                      teacherName: widget.teacherName,
                      date: _selectedDate,
                      timeSlot: _selectedSlot!,
                      status: AppConstants.statusPending,
                      discipline: _selectedDiscipline,
                    );
                    context.read<BookingBloc>().add(
                          BookingCreateRequested(booking),
                        );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          )),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
