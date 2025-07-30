import 'package:dailybudget/Model/data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'limit_event.dart';
import 'limit_state.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  LimitBloc() : super(InitialState(dataModel:  DataModel())) {
    final dataModel = DataModel();

    on<LoadDataEvent>((event, emit) async {

      final prefs = await SharedPreferences.getInstance();
      dataModel.getFromPreferences(prefs);

      emit(InitialState(dataModel: dataModel));
    });

    on<AddSpendingEvent>((event, emit) {
      dataModel.actualLimit -= event.spending;
      dataModel.budget -= event.spending;
      emit(SpendingAddedState(dataModel.actualLimit));
    });

    on<UpdateLimitEvent>((event, emit) {
      dataModel.budget -= event.spending;
      int daysToPayday = dataModel.payday - dataModel.actualDate.day;
      if (daysToPayday < 0) {
        daysToPayday += DateTime(dataModel.actualDate.year, dataModel.actualDate.month + 1, 0).day;
      }
      
      dataModel.limit = (dataModel.budget / daysToPayday).clamp(0, dataModel.maxLimit);
      dataModel.actualLimit = dataModel.limit;

      emit(SpendingAddedState(dataModel.actualLimit));
    });

    on<BorrowEvent>((event, emit) {
      dataModel.budget -= event.spending;
      dataModel.borrow += event.difference;
      emit(SpendingAddedState(0.0));
    });
  }
}