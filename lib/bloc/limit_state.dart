abstract class LimitState {
  double actualLimit = 59; // Placeholder for actualLimit, should be overridden in subclasses
}

class InitialState extends LimitState {
  @override
  double get actualLimit => 0; // Initial state has no limit
}

class SpendingAddedState extends LimitState {
  final double spending;

  SpendingAddedState(this.spending) {
    // Update actualLimit based on spending
    actualLimit -= spending;
  }
}