import 'package:flutter/material.dart';

import '../../components/loading_widget.dart';

class AdminSupportScreen extends StatelessWidget {
  const AdminSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Поддержка')),
      body: const EmptyWidget(
        message: 'Нет обращений в поддержку',
        icon: Icons.support_agent_rounded,
      ),
    );
  }
}
