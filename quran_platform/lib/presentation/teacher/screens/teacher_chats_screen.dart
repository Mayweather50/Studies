import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme.dart';
import '../../components/avatar_view.dart';
import '../../components/loading_widget.dart';

class TeacherChatsScreen extends StatelessWidget {
  const TeacherChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Чаты')),
      body: const EmptyWidget(
        message: 'Нет активных чатов.\nЧаты появятся после принятия записей.',
        icon: Icons.chat_bubble_outline_rounded,
      ),
    );
  }
}
