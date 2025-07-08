import 'package:dailybudget/features/limit_calc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  LimitBloc() : super(LimitState(actualLimit: 50.0)) {
    on<UpdateLimit>((event, emit) {
      emit(state.copyWith(actualLimit: event.newLimit));
    });
  }
}