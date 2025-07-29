import 'package:dailybudget/Model/data_model.dart';
import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/features/limit_calc.dart';
import 'package:dailybudget/pages/overview.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  // Ensure that the Flutter engine is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final dataModel = DataModel();

  dataModel.getFromPreferences(prefs);

  final limitInstance = LimitCalc();

  // limitInstance.loadData(dataModel);

  


  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Budget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => LimitBloc(),
        child: const OverviewPage(),
      ),
    );
  }
}

