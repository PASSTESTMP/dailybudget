import 'package:dailybudget/Model/data_model.dart';

abstract class LimitState {
  double actualLimit = 0.0;
}

class InitialState extends LimitState {
  final DataModel dataModel;
  InitialState({required this.dataModel});

  InitialState copyWith({DataModel? dataModel}) {
    return InitialState(dataModel: dataModel ?? this.dataModel);
  }
}

class SpendingAddedState extends LimitState {
  final double newlLimit;

  SpendingAddedState(this.newlLimit){
    actualLimit = newlLimit;
  }
}