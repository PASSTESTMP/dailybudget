abstract class LimitEvent {}



class AddSpendingEvent extends LimitEvent {
  final double spending;

  AddSpendingEvent(this.spending);
}