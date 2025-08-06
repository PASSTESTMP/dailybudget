import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clock/clock.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

class FakeDataModel extends Fake implements DataModel {}

void main() {
  late MockLocalStorageService mockStorageService;
  late DataModel initialData;

  double testLimit = 100.0;
  double testActuallimit = 100.0;
  double testSpending = 50.0;
  double testBudget = 200.0;
  int testDaysAfterUpdate = 1;
  int testPayday = 10;
  double testMaxLimit = 100.0;
  int testSecondsOfNewDay = 2;
  DateTime testActualTime = DateTime(2025, 1, 1, 15, 0, 0);

  setUpAll(() {
    registerFallbackValue(FakeDataModel());
    withClock(Clock.fixed(testActualTime), () {
      expect(clock.now(), equals(testActualTime));
      expect(clock.now().hour, equals(15));
    });
  });

  setUp(() {
    mockStorageService = MockLocalStorageService();

    initialData = DataModel()
      ..actualLimit = testActuallimit
      ..budget = testBudget
      ..maxLimit = testMaxLimit
      ..payday = testPayday
      ..limit = testLimit
      ..lastUpdate = null;
  });

  group('Limitbloc', () {
    blocTest<LimitBloc, LimitState>(
      'emits updated LimitState when AddSpendingEvent is added',
      build: () {
        when(() => mockStorageService.getFromPreferences())
            .thenAnswer((_) async => initialData);

        when(() => mockStorageService.saveToPreferences(any()))
            .thenAnswer((_) async {});

        return LimitBloc(mockStorageService);
      },
      act: (bloc) => bloc.add(AddSpendingEvent(testSpending)),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          testActuallimit - testSpending,
        ).having(
          (s) => s.dataModel.budget,
          'budget',
          testBudget - testSpending,
        ),
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );
    blocTest<LimitBloc, LimitState>(
      'emits updated LimitState when date is changed',
      build: () {
        when(() => mockStorageService.getFromPreferences())
            .thenAnswer((_) async => initialData
            ..lastUpdate = DateTime.now().add(Duration(days: -testDaysAfterUpdate))
            );

        when(() => mockStorageService.saveToPreferences(any()))
            .thenAnswer((_) async {});

        return LimitBloc(mockStorageService);
      },
      act: (bloc) => bloc.add(LoadDataEvent()),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.lastUpdate!.day,
          'lastUpdate',
          DateTime.now().day,
        ).having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          testActuallimit + testDaysAfterUpdate * initialData.limit,
        )
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );

    blocTest<LimitBloc, LimitState>(
      'emits updated LimitState when date is changed long time',
      build: () {
        testDaysAfterUpdate = 20;
        when(() => mockStorageService.getFromPreferences())
            .thenAnswer((_) async => initialData
            ..lastUpdate = DateTime.now().add(Duration(days: -testDaysAfterUpdate))
            );

        when(() => mockStorageService.saveToPreferences(any()))
            .thenAnswer((_) async {});

        return LimitBloc(mockStorageService);
      },
      act: (bloc) => bloc.add(LoadDataEvent()),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.lastUpdate!.day,
          'lastUpdate',
          DateTime.now().day,
        ).having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          testActuallimit + testDaysAfterUpdate * initialData.limit,
        )
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );

    blocTest<LimitBloc, LimitState>(
      'emits updated LimitState when date is changed short time',
      build: () {
        testDaysAfterUpdate = 0;
        when(() => mockStorageService.getFromPreferences())
            .thenAnswer((_) async => initialData
            ..lastUpdate = DateTime.now().add(Duration(
              hours: -DateTime.now().hour,
              minutes: -DateTime.now().minute,
              seconds: -DateTime.now().second - testSecondsOfNewDay
              ))
            );

        when(() => mockStorageService.saveToPreferences(any()))
            .thenAnswer((_) async {});

        return LimitBloc(mockStorageService);
      },
      act: (bloc) => bloc.add(LoadDataEvent()),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.lastUpdate!.day,
          'lastUpdate',
          DateTime.now().day,
        ).having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          testActuallimit + initialData.limit,
        )
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );

    blocTest<LimitBloc, LimitState>(
      'emits updated LimitState when date is changed very short time',
      build: () {
        when(() => mockStorageService.getFromPreferences())
            .thenAnswer((_) async => initialData
            ..lastUpdate = DateTime.now().add(Duration(
              hours: -DateTime.now().hour,
              minutes: -DateTime.now().minute,
              seconds: -DateTime.now().second,
              milliseconds: -DateTime.now().millisecond - 1
              ))
            );

        when(() => mockStorageService.saveToPreferences(any()))
            .thenAnswer((_) async {});

        return LimitBloc(mockStorageService);
      },
      act: (bloc) => bloc.add(LoadDataEvent()),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.lastUpdate!.day,
          'lastUpdate',
          DateTime.now().day,
        ).having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          testActuallimit + initialData.limit,
        )
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );
  });
}