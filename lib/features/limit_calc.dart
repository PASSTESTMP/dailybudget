class LimitCalc {
  double budget = 0;
  double maxLimit = 100;
  DateTime actualDate = DateTime.now();
  int payday = 10;
  double actualLimit = 0;
  double borrow = 0;
  double limit = 0;
  DateTime? lastUpdate;
  bool limitBelowZero = false;

  void refreshDate() {
    lastUpdate = actualDate;
    actualDate = DateTime.now();
    
    if (lastUpdate != actualDate) {
      int daysFromLastUpdate = actualDate.difference(lastUpdate ?? actualDate).inDays;
      if (daysFromLastUpdate > 0) {
        actualLimit += limit * daysFromLastUpdate;
      }
    }
  }

  void updateLimit() {
    int daysToPayday = payday - actualDate.day;
    if (daysToPayday < 0) {
      daysToPayday += DateTime(actualDate.year, actualDate.month + 1, 0).day;
    }
    
    limit = (budget / daysToPayday).clamp(0, maxLimit);
    actualLimit = limit;
    limitBelowZero = false;
  }

  void addSpending(double spending) {
    if (actualLimit < spending) {
      double needed = spending - actualLimit;
      if (borrow >= needed) {
        borrow -= needed;
        actualLimit = 0;
      } else {
        limitBelowZero = true;
        updateLimit();
        // Pop-up limit below zero
        // User can choose to borrow or update limit
        // throw Exception('Limit below zero, consider borrowing or updating limit');
      }
    } else {
      actualLimit -= spending;
    }
    budget -= spending;
  }
}
