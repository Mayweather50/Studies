import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../components/avatar_view.dart';
import '../bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/student/settings'),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is! AuthAuthenticated) {
            return const Center(child: Text('Не авторизован'));
          }

          final user = state.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            child: Column(
              children: [
                AvatarView(
                  imageUrl: user.avatarUrl,
                  name: user.name,
                  size: 80,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  user.name.isEmpty ? 'Ученик' : user.name,
                  style: AppTextStyles.heading3,
                ),
                if (user.email != null)
                  Text(user.email!, style: AppTextStyles.bodySmall),
                if (user.phone != null)
                  Text(user.phone!, style: AppTextStyles.bodySmall),

                const SizedBox(height: AppTheme.spacingXL),

                _buildTile(
                  context,
                  icon: Icons.person_rounded,
                  title: 'Возрастная группа',
                  subtitle: user.age ?? 'Не указано',
                ),
                _buildTile(
                  context,
                  icon: Icons.bar_chart_rounded,
                  title: 'Уровень',
                  subtitle: user.level ?? 'Не указано',
                ),
                _buildTile(
                  context,
                  icon: Icons.favorite_rounded,
                  title: 'Избранные учителя',
                  subtitle: '${user.favoriteTeachers.length}',
                ),

                const SizedBox(height: AppTheme.spacingXL),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout_rounded,
                      color: AppColors.error),
                  title: Text(
                    'Выйти',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  onTap: () {
                    context.read<AuthBloc>().add(const AuthSignOutRequested());
                    context.go('/auth');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.labelSmall),
        subtitle: Text(subtitle, style: AppTextStyles.labelMedium),
      ),
    );
  }
}
