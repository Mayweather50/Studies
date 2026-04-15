import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/booking_entity.dart';
import 'package:quran_platform/presentation/components/booking_card.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  final pendingBooking = BookingEntity(
    id: 'b1',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз Мухаммад',
    date: DateTime(2026, 5, 1),
    timeSlot: '10:00',
    status: 'pending',
    discipline: 'Таджвид',
  );

  final confirmedBooking = BookingEntity(
    id: 'b2',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз Ибрахим',
    date: DateTime(2026, 3, 15),
    timeSlot: '14:00',
    status: 'confirmed',
    discipline: 'Хифз',
  );

  final cancelledBooking = BookingEntity(
    id: 'b3',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз Али',
    date: DateTime(2026, 7, 20),
    timeSlot: '09:00',
    status: 'cancelled',
    discipline: 'Тафсир',
  );

  final completedBooking = BookingEntity(
    id: 'b4',
    studentId: 's1',
    teacherId: 't1',
    studentName: 'Ахмад',
    teacherName: 'Устаз Омар',
    date: DateTime(2026, 12, 25),
    timeSlot: '16:00',
    status: 'completed',
    discipline: 'Таджвид',
  );

  group('BookingCard', () {
    testWidgets('shows teacher name by default', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking),
      ));

      expect(find.text('Устаз Мухаммад'), findsOneWidget);
    });

    testWidgets('shows student name when showTeacherName is false',
        (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking, showTeacherName: false),
      ));

      expect(find.text('Ахмад'), findsOneWidget);
    });

    testWidgets('shows discipline and time slot', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking),
      ));

      expect(find.text('Таджвид • 10:00'), findsOneWidget);
    });

    testWidgets('shows pending status badge', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking),
      ));

      expect(find.text('Ожидает'), findsOneWidget);
    });

    testWidgets('shows confirmed status badge', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: confirmedBooking),
      ));

      expect(find.text('Принят'), findsOneWidget);
    });

    testWidgets('shows cancelled status badge', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: cancelledBooking),
      ));

      expect(find.text('Отменён'), findsOneWidget);
    });

    testWidgets('shows completed status badge', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: completedBooking),
      ));

      expect(find.text('Завершён'), findsOneWidget);
    });

    testWidgets('shows day number from date', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking),
      ));

      // May 1st -> day = 1
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('shows correct month abbreviation', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: pendingBooking),
      ));

      // May -> май
      expect(find.text('май'), findsOneWidget);
    });

    testWidgets('shows March month abbreviation', (tester) async {
      await tester.pumpWidget(buildApp(
        BookingCard(booking: confirmedBooking),
      ));

      expect(find.text('мар'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildApp(
        BookingCard(
          booking: pendingBooking,
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(BookingCard));
      expect(tapped, isTrue);
    });
  });
}
