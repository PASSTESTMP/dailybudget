abstract class LimitEvent {}

class UpdateLimitEvent extends LimitEvent {
  final double spending;

  UpdateLimitEvent(this.spending);
}

class AddSpendingEvent extends LimitEvent {
  final double spending;

  AddSpendingEvent(this.spending);
}

class BorrowEvent extends LimitEvent {
  final double difference;

  BorrowEvent(this.difference);
}