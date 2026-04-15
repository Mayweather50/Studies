import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/custom_button.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('CustomButton', () {
    testWidgets('displays text', (tester) async {
      await tester.pumpWidget(buildApp(
        CustomButton(text: 'Записаться', onPressed: () {}),
      ));

      expect(find.text('Записаться'), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildApp(
        CustomButton(text: 'Tap', onPressed: () => pressed = true),
      ));

      await tester.tap(find.text('Tap'));
      expect(pressed, isTrue);
    });

    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(buildApp(
        const CustomButton(text: 'Loading', isLoading: true),
      ));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading'), findsNothing);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpWidget(buildApp(
        const CustomButton(text: 'Disabled', onPressed: null),
      ));

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('renders as OutlinedButton when isOutlined', (tester) async {
      await tester.pumpWidget(buildApp(
        CustomButton(text: 'Outlined', isOutlined: true, onPressed: () {}),
      ));

      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('displays icon when provided', (tester) async {
      await tester.pumpWidget(buildApp(
        CustomButton(
          text: 'Google',
          icon: Icons.g_mobiledata_rounded,
          onPressed: () {},
        ),
      ));

      expect(find.byIcon(Icons.g_mobiledata_rounded), findsOneWidget);
      expect(find.text('Google'), findsOneWidget);
    });

    testWidgets('does not trigger onPressed when loading', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(buildApp(
        CustomButton(
          text: 'Busy',
          isLoading: true,
          onPressed: () => pressed = true,
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isFalse);
    });
  });
}
