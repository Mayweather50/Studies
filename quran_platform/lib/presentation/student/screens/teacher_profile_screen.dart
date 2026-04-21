import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/avatar_view.dart';
import '../../components/custom_button.dart';
import '../../components/loading_widget.dart';
import '../../components/rating_view.dart';
import '../bloc/teacher_bloc.dart';

class TeacherProfileScreen extends StatelessWidget {
  final String teacherId;

  const TeacherProfileScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeacherBloc(
        getTeacherById: context.read(),
        getTeacherReviews: context.read(),
      )..add(TeacherLoadRequested(teacherId)),
      child: Scaffold(
        body: BlocBuilder<TeacherBloc, TeacherState>(
          builder: (context, state) {
            if (state is TeacherLoading) {
              return const LoadingWidget(message: 'Загрузка...');
            }
            if (state is TeacherError) {
              return ErrorWidget2(
                message: state.message,
                onRetry: () => context
                    .read<TeacherBloc>()
                    .add(TeacherLoadRequested(teacherId)),
              );
            }
            if (state is TeacherLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TeacherLoaded state) {
    final teacher = state.teacher;
    final reviews = state.reviews;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.primary.withValues(alpha: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Hero(
                    tag: 'teacher_$teacherId',
                    child: AvatarView(
                      imageUrl: teacher.photoUrl,
                      name: teacher.name,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(teacher.name, style: AppTextStyles.heading2),
                  const SizedBox(height: AppTheme.spacingS),
                  RatingView(rating: teacher.rating),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Disciplines
              Text('Дисциплины', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: teacher.disciplines.map((d) {
                  return Chip(
                    label: Text(d),
                    backgroundColor:
                        AppColors.primary.withValues(alpha: 0.1),
                    labelStyle: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppTheme.spacingL),
              Text('О преподавателе', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppTheme.spacingS),
              Text(teacher.bio, style: AppTextStyles.bodyMedium),

              const SizedBox(height: AppTheme.spacingL),
              Text('Опыт', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppTheme.spacingS),
              Text(teacher.experience, style: AppTextStyles.bodyMedium),

              // Levels
              const SizedBox(height: AppTheme.spacingL),
              Text('Уровни', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: teacher.levels.map((l) {
                  return Chip(
                    label: Text(l),
                    backgroundColor:
                        AppColors.secondary.withValues(alpha: 0.15),
                    labelStyle: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.secondaryDark,
                    ),
                  );
                }).toList(),
              ),

              // Age groups
              const SizedBox(height: AppTheme.spacingL),
              Text('Возрастные группы', style: AppTextStyles.labelLarge),
              const SizedBox(height: AppTheme.spacingS),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: teacher.ageGroups.map((a) {
                  return Chip(label: Text(a));
                }).toList(),
              ),

              // Reviews
              const SizedBox(height: AppTheme.spacingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Отзывы (${reviews.length})',
                      style: AppTextStyles.labelLarge),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              if (reviews.isEmpty)
                Text(
                  'Пока нет отзывов',
                  style: AppTextStyles.bodySmall,
                )
              else
                ...reviews.take(5).map((review) => Container(
                      margin:
                          const EdgeInsets.only(bottom: AppTheme.spacingS),
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review.studentName,
                                  style: AppTextStyles.labelSmall),
                              RatingView(
                                rating: review.rating.toDouble(),
                                size: 12,
                                showValue: false,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(review.comment,
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    )),

              const SizedBox(height: 100),
            ]),
          ),
        ),
      ],
    );
  }
}
