import 'package:dailybudget/Model/data_model.dart';

abstract class LimitEvent {}

class LoadDataEvent extends LimitEvent {}

class UpdateDataEvent extends LimitEvent {
  final DataModel newData;

  UpdateDataEvent(this.newData);
}

class UpdateLimitEvent extends LimitEvent {
  final double spending;

  UpdateLimitEvent(this.spending);
}

class AddSpendingEvent extends LimitEvent {
  final double spending;

  AddSpendingEvent(this.spending);
}

class BorrowEvent extends LimitEvent {
  final double spending;
  final double difference;

  BorrowEvent(this.difference, this.spending);
}