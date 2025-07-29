import 'package:flutter_bloc/flutter_bloc.dart';
import 'limit_event.dart';
import 'limit_state.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  LimitBloc() : super(InitialState()) {


    on<AddSpendingEvent>((event, emit) {
      emit(SpendingAddedState(event.spending));
    });
  }
}