import 'package:dailybudget/Model/data_model.dart';

abstract class LimitState {
  double actualLimit = 0.0;
  double limit = 0.0;
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
  final double targetLimit;

  SpendingAddedState(this.newlLimit, this.targetLimit) {
    actualLimit = newlLimit;
    limit = targetLimit;
  }
}