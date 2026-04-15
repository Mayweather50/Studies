import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/filter_chips.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  const testItems = ['Таджвид', 'Хифз', 'Тафсир', 'Коран для детей'];

  group('FilterChipRow', () {
    testWidgets('shows label', (tester) async {
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: testItems,
          onSelected: (_) {},
          label: 'Дисциплина',
        ),
      ));

      expect(find.text('Дисциплина'), findsOneWidget);
    });

    testWidgets('shows all items as chips', (tester) async {
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: testItems,
          onSelected: (_) {},
          label: 'Дисциплина',
        ),
      ));

      expect(find.text('Таджвид'), findsOneWidget);
      expect(find.text('Хифз'), findsOneWidget);
      expect(find.text('Тафсир'), findsOneWidget);
      expect(find.text('Коран для детей'), findsOneWidget);
    });

    testWidgets('calls onSelected when chip tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: testItems,
          onSelected: (s) => selected = s,
          label: 'Дисциплина',
        ),
      ));

      await tester.tap(find.text('Хифз'));
      await tester.pumpAndSettle();

      expect(selected, 'Хифз');
    });

    testWidgets('deselects when tapping already selected item',
        (tester) async {
      String? selected = 'Хифз';
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: testItems,
          selectedItem: 'Хифз',
          onSelected: (s) => selected = s,
          label: 'Дисциплина',
        ),
      ));

      await tester.tap(find.text('Хифз'));
      await tester.pumpAndSettle();

      // Should pass null to deselect
      expect(selected, isNull);
    });

    testWidgets('renders FilterChip widgets', (tester) async {
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: testItems,
          onSelected: (_) {},
          label: 'Уровень',
        ),
      ));

      expect(find.byType(FilterChip), findsNWidgets(4));
    });

    testWidgets('works with empty items list', (tester) async {
      await tester.pumpWidget(buildApp(
        FilterChipRow(
          items: const [],
          onSelected: (_) {},
          label: 'Пусто',
        ),
      ));

      expect(find.text('Пусто'), findsOneWidget);
      expect(find.byType(FilterChip), findsNothing);
    });
  });
}
