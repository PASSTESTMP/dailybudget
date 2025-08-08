import 'package:flutter/material.dart';

class  DataModel {
  double actualLimit = 0;
  double budget = 0;
  double maxLimit = 100;
  int payday = 10;
  double limit = 0;
  DateTime? lastUpdate;
  Locale locale = Locale('pl', 'PL');
  String currency = "zł";
}