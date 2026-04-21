import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../components/filter_chips.dart';
import '../../components/loading_widget.dart';
import '../../components/teacher_card.dart';
import '../bloc/home_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String? _discipline;
  String? _ageGroup;
  String? _level;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    context.read<HomeBloc>().add(
          HomeFilterChanged(
            discipline: _discipline,
            ageGroup: _ageGroup,
            level: _level,
            searchQuery: _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поиск')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _search(),
              decoration: InputDecoration(
                hintText: 'Поиск учителя...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _search();
                        },
                      )
                    : null,
              ),
            ),
          ),
          FilterChipRow(
            label: 'Дисциплина',
            items: AppConstants.disciplines,
            selectedItem: _discipline,
            onSelected: (v) {
              setState(() => _discipline = v);
              _search();
            },
          ),
          const SizedBox(height: AppTheme.spacingS),
          FilterChipRow(
            label: 'Возраст',
            items: AppConstants.ageGroups,
            selectedItem: _ageGroup,
            onSelected: (v) {
              setState(() => _ageGroup = v);
              _search();
            },
          ),
          const SizedBox(height: AppTheme.spacingS),
          FilterChipRow(
            label: 'Уровень',
            items: AppConstants.levels,
            selectedItem: _level,
            onSelected: (v) {
              setState(() => _level = v);
              _search();
            },
          ),
          const SizedBox(height: AppTheme.spacingM),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoading) {
                  return const LoadingWidget();
                }
                if (state is HomeLoaded) {
                  if (state.teachers.isEmpty) {
                    return const EmptyWidget(
                      message: 'Ничего не найдено',
                      icon: Icons.search_off_rounded,
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM),
                    itemCount: state.teachers.length,
                    itemBuilder: (context, index) {
                      final teacher = state.teachers[index];
                      return TeacherCard(
                        teacher: teacher,
                        onTap: () =>
                            context.push('/student/teacher/${teacher.id}'),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
