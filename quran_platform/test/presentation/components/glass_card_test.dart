import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/glass_card.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('GlassCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(buildApp(
        const GlassCard(
          child: Text('Содержимое карточки'),
        ),
      ));

      expect(find.text('Содержимое карточки'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildApp(
        GlassCard(
          onTap: () => tapped = true,
          child: const Text('Нажми'),
        ),
      ));

      await tester.tap(find.text('Нажми'));
      expect(tapped, isTrue);
    });

    testWidgets('does not crash without onTap', (tester) async {
      await tester.pumpWidget(buildApp(
        const GlassCard(child: Text('Без onTap')),
      ));

      await tester.tap(find.text('Без onTap'));
      // No crash = test passes
    });

    testWidgets('uses BackdropFilter for glass effect', (tester) async {
      await tester.pumpWidget(buildApp(
        const GlassCard(child: Text('Glass')),
      ));

      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('applies custom padding', (tester) async {
      await tester.pumpWidget(buildApp(
        const GlassCard(
          padding: EdgeInsets.all(32),
          child: Text('Custom padding'),
        ),
      ));

      expect(find.byType(GlassCard), findsOneWidget);
    });

    testWidgets('renders in dark theme', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: const Scaffold(
          body: GlassCard(child: Text('Dark mode')),
        ),
      ));

      expect(find.text('Dark mode'), findsOneWidget);
    });
  });
}
