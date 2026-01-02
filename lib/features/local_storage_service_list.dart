import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailybudget/Model/list_data_model.dart';

class LocalStorageServiceList {
  final ListDataModel dataModel;
  static const _dataKey = 'app_data_list';
  late SharedPreferences prefs;
  

  LocalStorageServiceList(this.dataModel);


  Future<ListDataModel> getFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // dataModel.actualLimit = prefs.getDouble('actualLimit') ?? 0;
    // dataModel.budget = prefs.getDouble('budget') ?? 0;
    // dataModel.maxLimit = prefs.getDouble('maxLimit') ?? 100;
    // dataModel.payday = prefs.getInt('payday') ?? 10;
    // dataModel.limit = prefs.getDouble('limit') ?? 0;
    // String? lastUpdateString = prefs.getString(_dataKey);
    // if (lastUpdateString != null) {
    //   dataModel.lastUpdate = DateTime.parse(lastUpdateString);
    // }
    return dataModel;
  }

  Future<void> saveToPreferences(ListDataModel newData) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setDouble('actualLimit', newData.actualLimit);
    // await prefs.setDouble('budget', newData.budget);
    // await prefs.setDouble('maxLimit', newData.maxLimit);
    // await prefs.setInt('payday', newData.payday);
    // await prefs.setDouble('limit', newData.limit);
    // if (newData.lastUpdate != null) {
    //   await prefs.setString(_dataKey, newData.lastUpdate!.toIso8601String());
    // }
  }
}
