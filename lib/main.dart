import 'package:dailybudget/block/limit_block.dart';
import 'package:dailybudget/pages/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(
    BlocProvider(
      create: (_) => LimitBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Limit Indicator Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LimitIndicatorPage(), // tutaj wchodzi Twój ekran
    );
  }
}

