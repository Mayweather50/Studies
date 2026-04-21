import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';
import 'package:quran_platform/presentation/components/teacher_card.dart';

void main() {
  Widget buildApp(Widget child) {
    return MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child)));
  }

  const testTeacher = TeacherEntity(
    id: 't1',
    name: 'Устаз Мухаммад',
    bio: 'Опытный преподаватель',
    experience: '10 лет',
    disciplines: ['Таджвид', 'Хифз'],
    levels: ['Начальный', 'Средний'],
    rating: 4.8,
    reviewCount: 25,
  );

  group('TeacherCard', () {
    testWidgets('shows teacher name', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      expect(find.text('Устаз Мухаммад'), findsOneWidget);
    });

    testWidgets('shows disciplines joined with bullet', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      expect(find.text('Таджвид • Хифз'), findsOneWidget);
    });

    testWidgets('shows review count', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      expect(find.text('(25)'), findsOneWidget);
    });

    testWidgets('shows level badges', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      expect(find.text('Начальный'), findsOneWidget);
      expect(find.text('Средний'), findsOneWidget);
    });

    testWidgets('shows chevron icon', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildApp(
        TeacherCard(
          teacher: testTeacher,
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.byType(TeacherCard));
      expect(tapped, isTrue);
    });

    testWidgets('shows at most 2 level badges', (tester) async {
      const teacherWith3Levels = TeacherEntity(
        id: 't2',
        name: 'Тест',
        bio: 'bio',
        experience: '1 год',
        disciplines: ['Таджвид'],
        levels: ['Новичок', 'Базовый', 'Продвинутый'],
        rating: 3.0,
        reviewCount: 5,
      );

      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: teacherWith3Levels),
      ));

      expect(find.text('Новичок'), findsOneWidget);
      expect(find.text('Базовый'), findsOneWidget);
      expect(find.text('Продвинутый'), findsNothing);
    });

    testWidgets('contains RatingView widget', (tester) async {
      await tester.pumpWidget(buildApp(
        const TeacherCard(teacher: testTeacher),
      ));

      // Rating stars should be present
      expect(find.byIcon(Icons.star_rounded), findsWidgets);
    });
  });
}
