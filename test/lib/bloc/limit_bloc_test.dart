import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

class FakeDataModel extends Fake implements DataModel {}

void main() {
  late MockLocalStorageService mockStorageService;
  late DataModel initialData;

  setUpAll(() {
    registerFallbackValue(FakeDataModel());
  });

  setUp(() {
    mockStorageService = MockLocalStorageService();

    initialData = DataModel()
      ..actualLimit = 100
      ..budget = 200
      ..maxLimit = 100
      ..actualDate = DateTime(2025, 1, 1)
      ..payday = 10
      ..limit = 100
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
      act: (bloc) => bloc.add(AddSpendingEvent(50)),
      expect: () => [
        isA<LimitState>().having(
          (s) => s.dataModel.actualLimit,
          'actualLimit',
          50,
        ).having(
          (s) => s.dataModel.budget,
          'budget',
          150,
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
            ..lastUpdate = DateTime.now().add(Duration(days: -1))
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
          200,
        )
      ],
      verify: (_) {
        verify(() => mockStorageService.getFromPreferences()).called(1);
        verify(() => mockStorageService.saveToPreferences(any())).called(1);
      },
    );
  });
}