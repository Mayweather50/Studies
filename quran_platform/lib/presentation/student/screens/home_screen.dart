import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../components/filter_chips.dart';
import '../../components/loading_widget.dart';
import '../../components/prayer_time_widget.dart';
import '../../components/teacher_card.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedDiscipline;
  String? _selectedAgeGroup;
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    double? lat, lng;
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final pos = await Geolocator.getCurrentPosition();
        lat = pos.latitude;
        lng = pos.longitude;
      }
    } catch (_) {}

    if (!mounted) return;
    context.read<HomeBloc>().add(
          HomeLoadRequested(latitude: lat, longitude: lng),
        );
  }

  void _applyFilters() {
    context.read<HomeBloc>().add(
          HomeFilterChanged(
            discipline: _selectedDiscipline,
            ageGroup: _selectedAgeGroup,
            level: _selectedLevel,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text('Ассаляму алейкум!', style: AppTextStyles.heading3),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadData(),
        color: AppColors.primary,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const LoadingWidget(message: 'Загрузка...');
            }
            if (state is HomeError) {
              return ErrorWidget2(
                message: state.message,
                onRetry: _loadData,
              );
            }
            if (state is HomeLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    return ListView(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXXL),
      children: [
        // Prayer times
        if (state.prayerTimes != null)
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: PrayerTimeWidget(prayerTimes: state.prayerTimes),
          ),

        // Disciplines horizontal scroll
        const SizedBox(height: AppTheme.spacingS),
        Padding(
          padding: const EdgeInsets.only(left: AppTheme.spacingM),
          child: Text('Дисциплины', style: AppTextStyles.labelSmall),
        ),
        const SizedBox(height: AppTheme.spacingS),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingM),
            itemCount: AppConstants.disciplines.length,
            itemBuilder: (context, index) {
              final d = AppConstants.disciplines[index];
              final isSelected = d == _selectedDiscipline;
              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingS),
                child: FilterChip(
                  label: Text(d),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedDiscipline = isSelected ? null : d;
                    });
                    _applyFilters();
                  },
                  selectedColor: AppColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: AppColors.primary,
                ),
              );
            },
          ),
        ),

        // Age filter
        const SizedBox(height: AppTheme.spacingM),
        FilterChipRow(
          label: 'Возраст',
          items: AppConstants.ageGroups,
          selectedItem: _selectedAgeGroup,
          onSelected: (v) {
            setState(() => _selectedAgeGroup = v);
            _applyFilters();
          },
        ),

        // Level filter
        const SizedBox(height: AppTheme.spacingM),
        FilterChipRow(
          label: 'Уровень',
          items: AppConstants.levels,
          selectedItem: _selectedLevel,
          onSelected: (v) {
            setState(() => _selectedLevel = v);
            _applyFilters();
          },
        ),

        // Teachers
        const SizedBox(height: AppTheme.spacingL),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Учителя', style: AppTextStyles.heading3),
              Text(
                '${state.teachers.length}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),

        if (state.teachers.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppTheme.spacingXL),
            child: EmptyWidget(
              message: 'Учителя не найдены',
              icon: Icons.person_search_rounded,
            ),
          )
        else
          ...state.teachers.map((teacher) => Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM),
                child: TeacherCard(
                  teacher: teacher,
                  onTap: () => context.push('/student/teacher/${teacher.id}'),
                ),
              )),
      ],
    );
  }
}
