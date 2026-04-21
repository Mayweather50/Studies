import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/avatar_view.dart';
import '../../components/loading_widget.dart';
import '../bloc/admin_bloc.dart';

class AdminTeachersListScreen extends StatelessWidget {
  const AdminTeachersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Учителя')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/admin/teacher/new'),
        child: const Icon(Icons.add_rounded),
      ),
      body: BlocBuilder<AdminBloc, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) return const LoadingWidget();
          if (state is AdminLoaded) {
            if (state.teachers.isEmpty) {
              return const EmptyWidget(
                message: 'Нет учителей',
                icon: Icons.school_rounded,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: state.teachers.length,
              itemBuilder: (context, index) {
                final teacher = state.teachers[index];
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: ListTile(
                    leading: AvatarView(
                      imageUrl: teacher.photoUrl,
                      name: teacher.name,
                      size: 48,
                    ),
                    title: Text(teacher.name,
                        style: AppTextStyles.labelMedium),
                    subtitle: Text(
                      teacher.disciplines.join(' • '),
                      style: AppTextStyles.caption,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: teacher.isActive
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                            AppTheme.radiusSmall),
                      ),
                      child: Text(
                        teacher.isActive ? 'Активен' : 'Неактивен',
                        style: AppTextStyles.caption.copyWith(
                          color: teacher.isActive
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusLarge),
                    ),
                    onTap: () =>
                        context.push('/admin/teacher/${teacher.id}'),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
