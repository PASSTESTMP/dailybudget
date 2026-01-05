import 'dart:convert';

import 'package:dailybudget/Model/list_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailybudget/Model/list_data_model.dart';

class LocalStorageServiceList {
  final ListDataModel dataModel;
  static const _dataKey = 'app_data_list';
  late SharedPreferences prefs;
  

  LocalStorageServiceList(this.dataModel);


  Future<ListDataModel> getFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    dataModel.id = prefs.getString('id') ?? '';
    dataModel.ownerId = prefs.getString('ownerId') ?? '';
    dataModel.sharedWith = prefs.getStringList('sharedWith') ?? [];
    String? itemsJson = prefs.getString('items');


    if (itemsJson != null) {
      final itemsToDecode = List<Map<String, dynamic>>.from(jsonDecode(itemsJson));
      dataModel.items = itemsToDecode
          .map((itemJson) => itemFromJson(itemJson))
          .toList();
    } else {
      dataModel.items = [];
    }

    return dataModel;
  }

  Future<void> saveToPreferences(ListDataModel newData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', newData.id);
    await prefs.setString('ownerId', newData.ownerId);
    await prefs.setStringList('sharedWith', newData.sharedWith);
    String itemsJson = newData.items.isNotEmpty
        ? jsonEncode(newData.items.map((item) => itemToJson(item)).toList())
        : '';
    await prefs.setString('items', itemsJson);

  }
}
