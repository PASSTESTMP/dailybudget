import 'dart:convert';

import 'package:dailybudget/Model/product_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServiceProd {
  final Products dataModel;
  // static const _dataKey = 'app_data';
  late SharedPreferences prefs;
  

  LocalStorageServiceProd(this.dataModel);


  Future<Products> getFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    dataModel.products = prefs.getString('products') != null
        ? (jsonDecode(prefs.getString('products')!) as List)
            .map((item) => Product.fromJson(item))
            .toList()
        : [];
    return dataModel;
  }

  Future<void> saveToPreferences(Products newData) async {
    final prefs = await SharedPreferences.getInstance();
    final productsJson = jsonEncode(newData.products.map((e) => e.toJson()).toList());
    await prefs.setString('products', productsJson);
  }
}