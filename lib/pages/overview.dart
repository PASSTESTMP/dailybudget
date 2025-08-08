import 'dart:io';
import 'dart:math';

import 'package:dailybudget/bloc/limit_bloc.dart';
import 'package:dailybudget/bloc/limit_event.dart';
import 'package:dailybudget/bloc/limit_state.dart';
import 'package:dailybudget/features/stt_service.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
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
  AppLocalizations? loc;

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
        title: Text(loc!.alertDialogLess),
        content: Text(loc!.alertDialogLessQestion),
        actions: [
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(UpdateLimitEvent(spending));
              Navigator.pop(context);
            },
            child: Text(loc!.yes),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(AddSpendingEvent(spending));
              Navigator.pop(context);
            },
            child: Text(loc!.no),
          ),
        ],
      ),
    );
  }

  void _showPopupUnderLimit(BuildContext parentContext, double spending) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: Text(loc!.alertDialogMore),
        content: Text(loc!.alertDialogMoreQestion),
        actions: [
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(UpdateLimitEvent(spending));
              Navigator.pop(context);
            },
            child: Text(loc!.update),
          ),
          TextButton(
            onPressed: () {
              parentContext.read<LimitBloc>().add(AddSpendingEvent(spending));
              Navigator.pop(context);
            },
            child: Text(loc!.borrow),
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

    loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc!.overviewTitle),
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
            double distanceSize = minimumWindowSize * 0.1;
            double strokeSize = minimumWindowSize * 0.1;
            int charNumber = limitValue.toStringAsFixed(2).length;
            double mainFontSize = minimumWindowSize * 0.7 / charNumber;
            double secondFontSize = minimumWindowSize * 0.08;

            // TODO: add currency parameter
            String currency = loc!.pln;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: distanceSize,
                ),
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
                        decoration: InputDecoration(
                          labelText: loc!.enterSpending,
                          border: const OutlineInputBorder(),
                          suffixText: currency,
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
                          SnackBar(content: Text(loc!.promptSttNotAvailable)),
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
                SizedBox(
                  height: distanceSize/2,
                ),
                ElevatedButton(
                  onPressed: () {
                    double spending = double.tryParse(_controller.text) ?? 0.0;
                    context.read<LimitBloc>().add(AddSpendingEvent(spending));
                    _controller.clear();
                  },
                  child: Text(loc!.send),
                ),
              ],
            );
          }
        )
      ),
    );
  }
}
