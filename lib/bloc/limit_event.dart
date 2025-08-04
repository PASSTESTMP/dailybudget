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

class UpdateBudgetEvent extends LimitEvent {
  final String budget;

  UpdateBudgetEvent(this.budget);
}

class UpdateMaxLimitEvent extends LimitEvent {
  final String maxLimit;

  UpdateMaxLimitEvent(this.maxLimit);
}

class UpdatePaydayEvent extends LimitEvent {
  final String payday;

  UpdatePaydayEvent(this.payday);
}

class UpdateBorrowEvent extends LimitEvent {
  final String borrow;

  UpdateBorrowEvent(this.borrow);
}

class UpdateLimitValueEvent extends LimitEvent {
  final String limit;

  UpdateLimitValueEvent(this.limit);
}

class SaveSettingsEvent extends LimitEvent {
  final DataModel dataModel;

  SaveSettingsEvent(this.dataModel);
}