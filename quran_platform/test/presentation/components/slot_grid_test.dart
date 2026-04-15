import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/presentation/components/slot_grid.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: child),
      ),
    );
  }

  group('SlotGrid', () {
    testWidgets('shows empty message when no slots', (tester) async {
      await tester.pumpWidget(buildApp(
        const SlotGrid(availableSlots: []),
      ));

      expect(find.text('Нет доступных слотов на выбранную дату'), findsOneWidget);
    });

    testWidgets('displays all available slots', (tester) async {
      await tester.pumpWidget(buildApp(
        const SlotGrid(
          availableSlots: ['08:00', '08:45', '09:30', '10:15'],
        ),
      ));

      expect(find.text('08:00'), findsOneWidget);
      expect(find.text('08:45'), findsOneWidget);
      expect(find.text('09:30'), findsOneWidget);
      expect(find.text('10:15'), findsOneWidget);
    });

    testWidgets('calls onSlotSelected when slot tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(buildApp(
        SlotGrid(
          availableSlots: const ['08:00', '08:45'],
          onSlotSelected: (s) => selected = s,
        ),
      ));

      await tester.tap(find.text('08:45'));
      expect(selected, '08:45');
    });

    testWidgets('shows selected slot differently', (tester) async {
      await tester.pumpWidget(buildApp(
        const SlotGrid(
          availableSlots: ['08:00', '08:45', '09:30'],
          selectedSlot: '08:45',
        ),
      ));

      // Verify slot is rendered (visual difference tested via golden tests)
      expect(find.text('08:45'), findsOneWidget);
    });

    testWidgets('booked slots are not selectable', (tester) async {
      String? selected;
      await tester.pumpWidget(buildApp(
        SlotGrid(
          availableSlots: const ['08:00', '08:45'],
          bookedSlots: const ['08:00'],
          onSlotSelected: (s) => selected = s,
        ),
      ));

      await tester.tap(find.text('08:00'));
      expect(selected, isNull);
    });
  });
}
