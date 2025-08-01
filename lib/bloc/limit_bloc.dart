import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/features/local_storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'limit_event.dart';
import 'limit_state.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  final LocalStorageService _storageService;

  LimitBloc(this._storageService) : super(LimitState(DataModel())){



    // on<UpdateDataEvent>((event, emit) async {
    //   dataModel.actualLimit = event.newData.actualLimit;
    //   dataModel.budget = event.newData.budget;
    //   dataModel.maxLimit = event.newData.maxLimit;
    //   dataModel.payday = event.newData.payday;
    //   dataModel.borrow = event.newData.borrow;
    //   dataModel.limit = event.newData.limit;
    //   dataModel.lastUpdate = event.newData.lastUpdate;

    //   await dataModel.saveToPreferences(await SharedPreferences.getInstance());
    //   final data = await _storageService.getFromPreferences();
    //   emit(LimitState(data));
    // });

    on<AddSpendingEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.actualLimit -= event.spending;
      newData.budget -= event.spending;

      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLimitEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.budget -= event.spending;
      int daysToPayday = newData.payday - newData.actualDate.day;
      if (daysToPayday < 0) {
        daysToPayday += DateTime(newData.actualDate.year, newData.actualDate.month + 1, 0).day;
      }
      
      newData.limit = (newData.budget / daysToPayday).clamp(0, newData.maxLimit);
      newData.actualLimit = newData.limit;

      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<BorrowEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.budget -= event.spending;
      newData.borrow += event.difference;
      newData.actualLimit = 0;
      
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

    on<UpdateBorrowEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.borrow = double.tryParse(event.borrow) ?? 0;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<UpdateLimitValueEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();

      newData.limit = double.tryParse(event.limit) ?? 0;
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<LoadDataEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      emit(LimitState(newData));
      await _storageService.saveToPreferences(newData);
    });

    on<SaveSettingsEvent>((event, emit) async {
      final newData = await _storageService.getFromPreferences();
      newData.budget = double.tryParse(event.dataModel.budget.toString()) ?? 0;
      newData.maxLimit = double.tryParse(event.dataModel.maxLimit.toString()) ?? 100;
      newData.payday = event.dataModel.payday;
      newData.borrow = double.tryParse(event.dataModel.borrow.toString()) ?? 0;
      newData.limit = double.tryParse(event.dataModel.limit.toString()) ?? 0;

      await _storageService.saveToPreferences(newData);
      emit(LimitState(newData));
    });
  }
}