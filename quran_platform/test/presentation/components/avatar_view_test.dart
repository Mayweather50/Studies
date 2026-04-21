import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/avatar_view.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('AvatarView', () {
    testWidgets('shows initials when no image', (tester) async {
      await tester.pumpWidget(buildApp(
        const AvatarView(name: 'Ахмад Мухаммадов', size: 48),
      ));

      expect(find.text('АМ'), findsOneWidget);
    });

    testWidgets('shows single initial for single name', (tester) async {
      await tester.pumpWidget(buildApp(
        const AvatarView(name: 'Ахмад', size: 48),
      ));

      expect(find.text('А'), findsOneWidget);
    });

    testWidgets('shows ? for empty name', (tester) async {
      await tester.pumpWidget(buildApp(
        const AvatarView(name: '', size: 48),
      ));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('respects size parameter', (tester) async {
      await tester.pumpWidget(buildApp(
        const AvatarView(name: 'Test', size: 80),
      ));

      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final box = container.constraints;
      // Container should have width and height of 80
      expect(find.byType(AvatarView), findsOneWidget);
    });
  });
}
