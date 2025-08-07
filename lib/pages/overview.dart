import 'dart:io';
import 'dart:math';

import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/features/stt_service.dart';
import 'package:dailybudget/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  final TextEditingController _controller = TextEditingController();

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _showPopupLessZero(BuildContext parentContext, double spending) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Spendings are less than zero'),
        content: const Text('Update limits after income?'),
        actions: [
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(UpdateLimitEvent(spending));
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(AddSpendingEvent(spending));
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _showPopupUnderLimit(BuildContext parentContext, double spending) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Spending are more than limit'),
        content: const Text('Update limit or borrow from next days?'),
        actions: [
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(UpdateLimitEvent(spending));
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(AddSpendingEvent(spending));
              Navigator.pop(context);
            },
            child: const Text('Borrow'),
          ),
        ],
      ),
    );
  }

  void _startSTT(TextEditingController controller) async {
    SttService sttService = SttService();
    await sttService.initialize();
    if (!sttService.isAvailable){}
    sttService.startListening(
      onResult: (result) {
        if (result.isNotEmpty) {
          // double spending = parsePolishNumber(result)!.toDouble() ?? 0.0;
          // double spending = double.tryParse(result.replaceAll(',', '.')) ?? 0.0;
          // context.read<LimitBloc>().add(AddSpendingEvent(spending));
          controller.text = result.replaceAll(',', '.');
        }
        
      }
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double limitValue = 0;
    Color circleColor = Colors.green;
    double limitPercentage = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: Center(
        child: BlocBuilder<LimitBloc, LimitState>(
          builder: (context, state) {
            limitValue = state.dataModel.actualLimit;
            if (limitValue != 0 && state.dataModel.limit != 0) {
              limitPercentage = (limitValue / state.dataModel.limit) * 100;
            } else {
              limitPercentage = 0;
            }
            circleColor = limitPercentage > 70
                ? Colors.green
                : (limitValue > 30 ? Colors.orange : Colors.red);

            if (limitValue < 0) {
              circleColor = Colors.red;
              limitPercentage = 100;
            }
            double windowWidth = MediaQuery.of(context).size.width;
            double windowHeight = MediaQuery.of(context).size.height;
            double minimumWindowSize = min(windowWidth, windowHeight);
            double boxSize = minimumWindowSize * 0.5;
            double distanceSize = minimumWindowSize * 0.2;
            double strokeSize = minimumWindowSize * 0.1;
            double mainFontSize = limitValue >= 100 ? minimumWindowSize * 0.11 : minimumWindowSize * 0.15;
            double secondFontSize = minimumWindowSize * 0.08;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Limit Indicator
                SizedBox(
                  width: boxSize,
                  height: boxSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: limitPercentage / 100,
                        strokeCap: StrokeCap.round,
                        strokeWidth: strokeSize,
                        strokeAlign: 5,
                        color: circleColor,
                        backgroundColor: Colors.grey[300],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            limitValue.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: mainFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'zł',
                            style: TextStyle(
                              fontSize: secondFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: distanceSize,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: boxSize,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Enter Spending',
                          border: OutlineInputBorder(),
                          suffixText: "zł"
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d{0,10}[,]?\d{0,2}$'),
                          ),
                        ],
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            double spending = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                            if (spending < 0) {
                              _showPopupLessZero(context, spending);
                            } else if (spending > limitValue) {
                              _showPopupUnderLimit(context, spending);
                            } else {
                              context.read<LimitBloc>().add(AddSpendingEvent(spending));
                            }
                          }
                          _controller.clear();
                        }
                      )
                    ),
                    Listener(
                      onPointerDown: (_) {
                        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Speech-to-text is not supported on this platform')),
                          );
                        } else {
                          _startSTT(_controller);
                        }
                        },
                        child: ElevatedButton(
                          onPressed: null, // Disable default onPressed
                          child: const Icon(Icons.mic),
                        ),
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    double spending = double.tryParse(_controller.text) ?? 0.0;
                    context.read<LimitBloc>().add(AddSpendingEvent(spending));
                    _controller.clear();
                  },
                  child: const Text("Send"),
                ),
              ],
            );
          }
        )
      ),
    );
  }
}
