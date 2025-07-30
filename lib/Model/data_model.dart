
import 'package:shared_preferences/shared_preferences.dart';

class  DataModel {
  double actualLimit = 0;
  double budget = 0;
  double maxLimit = 100;
  DateTime actualDate = DateTime.now();
  int payday = 10;
  double borrow = 0;
  double limit = 0;
  DateTime? lastUpdate;

  void getFromPreferences(SharedPreferences prefs) {
    actualLimit = prefs.getDouble('actualLimit') ?? 0;
    budget = prefs.getDouble('budget') ?? 0;
    maxLimit = prefs.getDouble('maxLimit') ?? 100;
    payday = prefs.getInt('payday') ?? 10;
    borrow = prefs.getDouble('borrow') ?? 0;
    limit = prefs.getDouble('limit') ?? 0;
    String? lastUpdateString = prefs.getString('lastUpdate');
    if (lastUpdateString != null) {
      lastUpdate = DateTime.parse(lastUpdateString);
    }
  }

  Future<void> saveToPreferences(SharedPreferences prefs) async {
    await prefs.setDouble('actualLimit', actualLimit);
    await prefs.setDouble('budget', budget);
    await prefs.setDouble('maxLimit', maxLimit);
    await prefs.setInt('payday', payday);
    await prefs.setDouble('borrow', borrow);
    await prefs.setDouble('limit', limit);
    if (lastUpdate != null) {
      await prefs.setString('lastUpdate', lastUpdate!.toIso8601String());
    }
  }
}