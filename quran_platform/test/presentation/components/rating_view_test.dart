import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/rating_view.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('RatingView', () {
    testWidgets('shows 5 star icons', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 3.0),
      ));

      final starIcons = find.byType(Icon);
      expect(starIcons, findsNWidgets(5));
    });

    testWidgets('shows correct full stars for rating 4.0', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 4.0),
      ));

      final fullStars = find.byIcon(Icons.star_rounded);
      expect(fullStars, findsNWidgets(4));
    });

    testWidgets('shows half star for decimal rating', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 3.5),
      ));

      expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
    });

    testWidgets('shows rating value text when showValue is true', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 4.5, showValue: true),
      ));

      expect(find.text('4.5'), findsOneWidget);
    });

    testWidgets('hides rating value text when showValue is false', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 4.5, showValue: false),
      ));

      expect(find.text('4.5'), findsNothing);
    });

    testWidgets('handles rating 0', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 0.0),
      ));

      expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
    });

    testWidgets('handles rating 5', (tester) async {
      await tester.pumpWidget(buildApp(
        const RatingView(rating: 5.0),
      ));

      expect(find.byIcon(Icons.star_rounded), findsNWidgets(5));
      expect(find.byIcon(Icons.star_outline_rounded), findsNothing);
    });
  });
}
