import 'package:dailybudget/block/limit_block.dart';
import 'package:dailybudget/features/limit_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LimitIndicatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Limit Indicator')),
      body: Center(
        child: BlocBuilder<LimitBloc, LimitState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Limit:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  '${state.actualLimit.toStringAsFixed(2)} zł',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Slider(
                  value: state.actualLimit,
                  min: 0,
                  max: 100,
                  onChanged: (value) {
                    context.read<LimitBloc>().add(UpdateLimit(value));
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}