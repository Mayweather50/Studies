import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_platform/domain/entities/prayer_time_entity.dart';
import 'package:quran_platform/domain/entities/teacher_entity.dart';
import 'package:quran_platform/domain/usecases/prayer_usecases.dart';
import 'package:quran_platform/domain/usecases/teacher_usecases.dart';
import 'package:quran_platform/presentation/student/bloc/home_bloc.dart';

class MockGetTeachers extends Mock implements GetTeachers {}
class MockGetPrayerTimes extends Mock implements GetPrayerTimes {}

void main() {
  late HomeBloc homeBloc;
  late MockGetTeachers mockGetTeachers;
  late MockGetPrayerTimes mockGetPrayerTimes;

  const teachers = [
    TeacherEntity(
      id: '1', name: 'Устаз 1', bio: 'Bio 1', experience: '5 лет',
      disciplines: ['Таджвид'], isActive: true,
    ),
    TeacherEntity(
      id: '2', name: 'Устаз 2', bio: 'Bio 2', experience: '10 лет',
      disciplines: ['Хифз'], isActive: true,
    ),
  ];

  const prayerTimes = PrayerTimeEntity(
    fajr: '05:00', sunrise: '06:30', dhuhr: '12:00',
    asr: '15:00', maghrib: '18:00', isha: '19:30',
    date: '15 Mar 2024',
  );

  setUpAll(() {
    registerFallbackValue(const GetTeachersParams());
    registerFallbackValue(const PrayerTimesParams(latitude: 0, longitude: 0));
  });

  setUp(() {
    mockGetTeachers = MockGetTeachers();
    mockGetPrayerTimes = MockGetPrayerTimes();

    homeBloc = HomeBloc(
      getTeachers: mockGetTeachers,
      getPrayerTimes: mockGetPrayerTimes,
    );
  });

  tearDown(() => homeBloc.close());

  test('initial state is HomeInitial', () {
    expect(homeBloc.state, const HomeInitial());
  });

  group('HomeLoadRequested', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] with teachers and prayer times',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => teachers);
        when(() => mockGetPrayerTimes(any()))
            .thenAnswer((_) async => prayerTimes);
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested(
        latitude: 42.98, longitude: 47.50,
      )),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(2))
            .having((s) => s.prayerTimes, 'prayerTimes', isNotNull),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] without prayer times when no coords',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => teachers);
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(2))
            .having((s) => s.prayerTimes, 'prayerTimes', isNull),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] even if prayer times fail',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => teachers);
        when(() => mockGetPrayerTimes(any()))
            .thenThrow(Exception('Network error'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested(
        latitude: 42.98, longitude: 47.50,
      )),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.prayerTimes, 'prayerTimes', isNull),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] on teachers fetch failure',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenThrow(Exception('Server error'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeLoadRequested()),
      expect: () => [
        const HomeLoading(),
        isA<HomeError>(),
      ],
    );
  });

  group('HomeFilterChanged', () {
    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeLoaded] with filtered teachers',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => [teachers[0]]);
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeFilterChanged(
        discipline: 'Таджвид',
      )),
      expect: () => [
        const HomeLoading(),
        isA<HomeLoaded>()
            .having((s) => s.teachers, 'teachers', hasLength(1))
            .having((s) => s.selectedDiscipline, 'discipline', 'Таджвид'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'passes all filter params to usecase',
      build: () {
        when(() => mockGetTeachers(any()))
            .thenAnswer((_) async => []);
        return homeBloc;
      },
      act: (bloc) => bloc.add(const HomeFilterChanged(
        discipline: 'Хифз',
        ageGroup: 'Дети (6-12)',
        level: 'Новичок',
        searchQuery: 'test',
      )),
      verify: (_) {
        final captured = verify(() => mockGetTeachers(captureAny())).captured;
        final params = captured.first as GetTeachersParams;
        expect(params.discipline, 'Хифз');
        expect(params.ageGroup, 'Дети (6-12)');
        expect(params.level, 'Новичок');
        expect(params.searchQuery, 'test');
      },
    );
  });
}
