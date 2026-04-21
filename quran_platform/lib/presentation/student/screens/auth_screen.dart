import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../components/custom_button.dart';
import '../../components/islamic_pattern_painter.dart';
import '../bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isPhoneMode = false;
  String? _verificationId;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final role = state.user.role;
          if (role == AppConstants.roleAdmin) {
            context.go('/admin');
          } else if (role == AppConstants.roleTeacher) {
            context.go('/teacher');
          } else {
            context.go('/student');
          }
        } else if (state is AuthPhoneCodeSent) {
          setState(() => _verificationId = state.verificationId);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IslamicPatternBackground(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                children: [
                  const SizedBox(height: AppTheme.spacingXXL),
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  Text(
                    AppConstants.appName,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingXXL),
                  Text(
                    'Войти в аккаунт',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'Выберите способ входа',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXL),

                  if (!_isPhoneMode && _verificationId == null) ...[
                    // Google sign-in
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Войти через Google',
                          icon: Icons.g_mobiledata_rounded,
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(const AuthGoogleSignInRequested());
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingM,
                          ),
                          child: Text(
                            'или',
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    // Phone sign-in button
                    CustomButton(
                      text: 'Войти по номеру телефона',
                      icon: Icons.phone_rounded,
                      isOutlined: true,
                      onPressed: () => setState(() => _isPhoneMode = true),
                    ),
                  ],

                  if (_isPhoneMode && _verificationId == null) ...[
                    // Phone input
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Номер телефона',
                        hintText: '+7 (999) 123-45-67',
                        prefixIcon: Icon(Icons.phone_rounded),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Получить код',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            final phone = _phoneController.text.trim();
                            if (Validators.phone(phone) == null) {
                              context.read<AuthBloc>().add(
                                    AuthPhoneSignInRequested(phone),
                                  );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    TextButton(
                      onPressed: () => setState(() => _isPhoneMode = false),
                      child: const Text('Назад'),
                    ),
                  ],

                  if (_verificationId != null) ...[
                    // Code input
                    Text(
                      'Введите код из SMS',
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.heading3,
                      decoration: const InputDecoration(
                        hintText: '000000',
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Подтвердить',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  AuthPhoneCodeVerified(
                                    verificationId: _verificationId!,
                                    code: _codeController.text.trim(),
                                  ),
                                );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    TextButton(
                      onPressed: () => setState(() {
                        _verificationId = null;
                        _isPhoneMode = false;
                      }),
                      child: const Text('Назад'),
                    ),
                  ],

                  const SizedBox(height: AppTheme.spacingXL),
                  // Teacher/Admin login link
                  TextButton(
                    onPressed: () => context.go('/teacher-login'),
                    child: Text(
                      'Вход для учителей',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
