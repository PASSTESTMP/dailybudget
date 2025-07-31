import 'package:dailybudget/Model/data_model.dart';

abstract class LimitState {
  double actualLimit = 0.0;
  double limit = 0.0;
  DataModel dataModel = DataModel();
  bool isLoading = false;
}

class InitialState extends LimitState {
  final DataModel newDataModel;
  InitialState({required this.newDataModel}){
    dataModel = newDataModel;
  }

  InitialState copyWith({DataModel? dataModel}) {
    return InitialState(newDataModel: this.dataModel);
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
