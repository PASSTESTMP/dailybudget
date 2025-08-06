import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'limit_event.dart';
import 'limit_state.dart';
import 'package:clock/clock.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  final LocalStorageService _storageService;

  LimitBloc(this._storageService) : super(LimitState(DataModel())){

    on<LoadDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      DateTime actualDate = clock.now();

      if (newData.lastUpdate != null) {
        bool isNewDay = actualDate.day != newData.lastUpdate!.day ||
            actualDate.month != newData.lastUpdate!.month ||
            actualDate.year != newData.lastUpdate!.year;

        if (isNewDay) {
          int daysAfterCheck = (actualDate.difference(newData.lastUpdate!).inSeconds.abs()/(24*60*60)).ceil();
          newData.actualLimit += newData.limit * daysAfterCheck;
        }
      }
      newData.lastUpdate = actualDate;

      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<AddSpendingEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.actualLimit -= event.spending;
      newData.budget -= event.spending;

      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLimitEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      DateTime actualDate = clock.now();

      newData.budget -= event.spending;
      int daysToPayday = newData.payday - actualDate.day;
      if (daysToPayday <= 0) {
        daysToPayday = (DateTime(actualDate.year, actualDate.month + 1, newData.payday).difference(actualDate).inHours.toDouble()/24).ceil();
      }
      
      newData.limit = (newData.budget / daysToPayday).clamp(0, newData.maxLimit);
      newData.actualLimit = newData.limit;

      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateBudgetEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.budget = double.tryParse(event.budget) ?? 0;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateMaxLimitEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.maxLimit = double.tryParse(event.maxLimit) ?? 0;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdatePaydayEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.payday = int.tryParse(event.payday) ?? 10;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLimitValueEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.limit = double.tryParse(event.limit) ?? 0;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<SaveSettingsEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      newData.budget = double.tryParse(event.dataModel.budget.toString()) ?? 0;
      newData.maxLimit = double.tryParse(event.dataModel.maxLimit.toString()) ?? 100;
      newData.payday = event.dataModel.payday;
      newData.limit = double.tryParse(event.dataModel.limit.toString()) ?? 0;

      await _storageService.saveToPreferences(newData);
      emit(LimitState(newData));
    });
  }
}