import 'package:dailybudget/features/limit_calc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LimitCalc', () {
    final limitCalc = LimitCalc();
    test('Check initial values', () {
      expect(limitCalc.actualLimit, 0);
    });
    test('Update limit with valid value', () {
      limitCalc.actualDate = DateTime(2023, 6, 12);
      limitCalc.payday = 10;
      limitCalc.budget = 10000;
      limitCalc.maxLimit = 100;
      limitCalc.updateLimit();
      expect(limitCalc.actualLimit, 100);
    });
    test('Update limit with budget less than max limit', () {
      limitCalc.actualDate = DateTime(2023, 6, 12);
      limitCalc.payday = 10;
      limitCalc.budget = 1000;
      limitCalc.maxLimit = 100;
      limitCalc.budget = 100;
      limitCalc.updateLimit();
      expect(limitCalc.actualLimit, limitCalc.budget/28);
    });
  });
  group('Spendings', () {
    final limitCalc = LimitCalc();
    test('Add spending within limit', () {
      limitCalc.budget = 10000;
      limitCalc.actualLimit = 100;
      limitCalc.addSpending(50);
      expect(limitCalc.actualLimit, 50);
      expect(limitCalc.budget, 10000 - 50);
    });
    test('Add spending exceeding limit', () {
      limitCalc.actualLimit = 50;
      expect(() => limitCalc.addSpending(70), throwsException);
    });
  });
}
