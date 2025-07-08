class LimitCalc {
  double budget = 0;
  double maxLimit = 100;
  DateTime actualDate = DateTime.now();
  int payday = 10;
  double actualLimit = 0;
  double borrow = 0;
  double limit = 0;
  DateTime? lastUpdate;

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
  }

  void addSpending(double spending) {
    if (actualLimit < spending) {
      double needed = spending - actualLimit;
      if (borrow >= needed) {
        borrow -= needed;
        actualLimit = 0;
      } else {
        // Pop-up limit below zero
        // User can choose to borrow or update limit
        throw Exception('Limit below zero, consider borrowing or updating limit');
      }
    } else {
      actualLimit -= spending;
    }
    budget -= spending;
  }

  /*
  Is __actual_date__ is 12.06., __payday__ is 10. everymonth:
__budget__ = 10000
__max_limit__ = 100

event:
__updateLimit()__

check:
__days_to_payday__ == 28
__limit__ = min(100, 10000/28) = 100
__actual_limit__ = 100

Event:
add __sepnding__ = 10

check:
__actual_limit__ = 90
__budget__ = 9990

Event:
add __spending__ = 100

chcek:
pop-up __limit_below_zero()__
    A. __borrow__ = 10
    or
    B. __updateLimit()__


A.
check:
__actual_limit__ == 0
__borrow__ == 10
__budget__ == 9890

event:
change __actual_date__ = 13.06.

check:
__actual_limit__ == 90
__borrow__ == 0

event:
change __actual_date__ = 14.06.

check:
__actual_limit__ == 190
__limit__ == 100

B.
check:
__limit__ = min(100, 9890/28) = 100
__actual_limit__ == 100
__borrow__ == 0
__budget__ == 9890
  */
  
}

abstract class LimitEvent {}

class UpdateLimit extends LimitEvent {
  final double newLimit;

  UpdateLimit(this.newLimit);
}


class LimitState {
  final double actualLimit;

  LimitState({required this.actualLimit});

  LimitState copyWith({double? actualLimit}) {
    return LimitState(
      actualLimit: actualLimit ?? this.actualLimit,
    );
  }
}

