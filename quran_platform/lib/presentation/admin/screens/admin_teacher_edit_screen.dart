import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/teacher_entity.dart';
import '../../components/avatar_view.dart';
import '../../components/custom_button.dart';
import '../bloc/admin_bloc.dart';

class AdminTeacherEditScreen extends StatefulWidget {
  final String? teacherId;

  const AdminTeacherEditScreen({super.key, this.teacherId});

  @override
  State<AdminTeacherEditScreen> createState() => _AdminTeacherEditScreenState();
}

class _AdminTeacherEditScreenState extends State<AdminTeacherEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();

  List<String> _selectedDisciplines = [];
  List<String> _selectedAgeGroups = [];
  List<String> _selectedLevels = [];
  bool _isActive = true;
  bool _isNew = true;

  @override
  void initState() {
    super.initState();
    _isNew = widget.teacherId == null || widget.teacherId == 'new';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is AdminTeacherSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Учитель сохранён'),
              backgroundColor: AppColors.success,
            ),
          );
          context.pop();
        } else if (state is AdminTeacherDeleted) {
          context.pop();
        } else if (state is AdminError) {
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
          title: Text(_isNew ? 'Новый учитель' : 'Редактировать'),
          actions: [
            if (!_isNew)
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppColors.error),
                onPressed: _confirmDelete,
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo placeholder
                Center(
                  child: Stack(
                    children: [
                      AvatarView(name: _nameController.text, size: 80),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Name
                TextFormField(
                  controller: _nameController,
                  validator: Validators.name,
                  decoration: const InputDecoration(
                    labelText: 'Имя учителя',
                    prefixIcon: Icon(Icons.person_rounded),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),

                // Bio
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  validator: (v) => Validators.required(v, 'описание'),
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingM),

                // Experience
                TextFormField(
                  controller: _experienceController,
                  maxLines: 2,
                  validator: (v) => Validators.required(v, 'опыт'),
                  decoration: const InputDecoration(
                    labelText: 'Опыт',
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Disciplines
                Text('Дисциплины', style: AppTextStyles.labelMedium),
                const SizedBox(height: AppTheme.spacingS),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.disciplines.map((d) {
                    final selected = _selectedDisciplines.contains(d);
                    return FilterChip(
                      label: Text(d),
                      selected: selected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedDisciplines.add(d);
                          } else {
                            _selectedDisciplines.remove(d);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Age groups
                Text('Возрастные группы', style: AppTextStyles.labelMedium),
                const SizedBox(height: AppTheme.spacingS),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.ageGroups.map((a) {
                    final selected = _selectedAgeGroups.contains(a);
                    return FilterChip(
                      label: Text(a),
                      selected: selected,
                      selectedColor: AppColors.secondary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.secondaryDark,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedAgeGroups.add(a);
                          } else {
                            _selectedAgeGroups.remove(a);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Levels
                Text('Уровни', style: AppTextStyles.labelMedium),
                const SizedBox(height: AppTheme.spacingS),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.levels.map((l) {
                    final selected = _selectedLevels.contains(l);
                    return FilterChip(
                      label: Text(l),
                      selected: selected,
                      selectedColor: AppColors.info.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.info,
                      onSelected: (v) {
                        setState(() {
                          if (v) {
                            _selectedLevels.add(l);
                          } else {
                            _selectedLevels.remove(l);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppTheme.spacingL),

                // Active switch
                SwitchListTile(
                  title: Text('Активен', style: AppTextStyles.labelMedium),
                  subtitle: const Text('Отображается в списке учителей'),
                  value: _isActive,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isActive = v),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                ),

                const SizedBox(height: AppTheme.spacingM),

                // Create credentials button
                if (_isNew)
                  CustomButton(
                    text: 'Создать логин/пароль',
                    icon: Icons.vpn_key_rounded,
                    isOutlined: true,
                    onPressed: _showCredentialsDialog,
                  ),

                const SizedBox(height: AppTheme.spacingL),

                // Save
                BlocBuilder<AdminBloc, AdminState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'Сохранить',
                      isLoading: state is AdminLoading,
                      onPressed: _save,
                    );
                  },
                ),

                const SizedBox(height: AppTheme.spacingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final teacher = TeacherEntity(
      id: _isNew ? '' : widget.teacherId!,
      name: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      experience: _experienceController.text.trim(),
      disciplines: _selectedDisciplines,
      ageGroups: _selectedAgeGroups,
      levels: _selectedLevels,
      isActive: _isActive,
    );

    if (_isNew) {
      context.read<AdminBloc>().add(AdminTeacherCreateRequested(teacher));
    } else {
      context.read<AdminBloc>().add(AdminTeacherUpdateRequested(teacher));
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить учителя?'),
        content: const Text('Это действие нельзя отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<AdminBloc>()
                  .add(AdminTeacherDeleteRequested(widget.teacherId!));
            },
            child: const Text('Удалить',
                style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showCredentialsDialog() {
    final name = _nameController.text.trim().toLowerCase().replaceAll(' ', '.');
    final email = '$name@quranplatform.ru';
    final password =
        'Qp${Random().nextInt(9000) + 1000}!';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Данные для входа'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email:', style: AppTextStyles.caption),
            SelectableText(email, style: AppTextStyles.labelMedium),
            const SizedBox(height: AppTheme.spacingM),
            Text('Пароль:', style: AppTextStyles.caption),
            SelectableText(password, style: AppTextStyles.labelMedium),
            const SizedBox(height: AppTheme.spacingM),
            Text(
              'Сохраните эти данные и передайте учителю',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.warning,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }
}
