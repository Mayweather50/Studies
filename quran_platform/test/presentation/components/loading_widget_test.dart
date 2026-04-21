import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/loading_widget.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('LoadingWidget', () {
    testWidgets('shows CircularProgressIndicator', (tester) async {
      await tester.pumpWidget(buildApp(const LoadingWidget()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows message when provided', (tester) async {
      await tester.pumpWidget(buildApp(
        const LoadingWidget(message: 'Загрузка...'),
      ));
      expect(find.text('Загрузка...'), findsOneWidget);
    });

    testWidgets('does not show message when null', (tester) async {
      await tester.pumpWidget(buildApp(const LoadingWidget()));
      expect(find.byType(Text), findsNothing);
    });
  });

  group('EmptyWidget', () {
    testWidgets('shows message and icon', (tester) async {
      await tester.pumpWidget(buildApp(
        const EmptyWidget(
          message: 'Нет данных',
          icon: Icons.inbox_outlined,
        ),
      ));

      expect(find.text('Нет данных'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('uses default icon', (tester) async {
      await tester.pumpWidget(buildApp(
        const EmptyWidget(message: 'Пусто'),
      ));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });
  });

  group('ErrorWidget2', () {
    testWidgets('shows error message and icon', (tester) async {
      await tester.pumpWidget(buildApp(
        const ErrorWidget2(message: 'Ошибка сервера'),
      ));

      expect(find.text('Ошибка сервера'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('shows retry button when onRetry provided', (tester) async {
      await tester.pumpWidget(buildApp(
        ErrorWidget2(message: 'Error', onRetry: () {}),
      ));

      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('hides retry button when onRetry is null', (tester) async {
      await tester.pumpWidget(buildApp(
        const ErrorWidget2(message: 'Error'),
      ));

      expect(find.text('Повторить'), findsNothing);
    });

    testWidgets('calls onRetry when retry tapped', (tester) async {
      bool retried = false;
      await tester.pumpWidget(buildApp(
        ErrorWidget2(message: 'Error', onRetry: () => retried = true),
      ));

      await tester.tap(find.text('Повторить'));
      expect(retried, isTrue);
    });
  });
}
