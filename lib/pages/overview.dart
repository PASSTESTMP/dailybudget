import 'package:dailybudget/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({Key? key}) : super(key: key);

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _showPopupLessZero(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spendings are less than zero'),
        content: const Text('Update limits after income?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _showPopupUnderLimit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spending are more than limit'),
        content: const Text('Update limit or borrow from next days?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Update'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Borrow'),
          ),
        ],
      ),
    );
  }

  void _startSTT() {

  }

  void _addSpending(double spending) {
    // This function should handle the logic to add spending
    // and update the budget and limits accordingly.
    // For now, it's just a placeholder.
  }

  @override
  Widget build(BuildContext context) {
    // Example limit value and color
    double limitValue = 75; // out of 100
    Color circleColor = limitValue < 50
        ? Colors.green
        : (limitValue < 80 ? Colors.orange : Colors.red);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Limit Indicator
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: limitValue / 100,
                    strokeCap: StrokeCap.round,
                    strokeWidth: 30,
                    strokeAlign: 5,
                    color: circleColor,
                    backgroundColor: Colors.grey[300],
                  ),
                  Text(
                    '${limitValue.toInt()}',
                    style: const TextStyle(
                      fontSize: 84,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
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
                        RegExp(r'^-?\d{0,10}[,]?\d{0,2}$'), // pozwala na liczby, przecinek, minus
                      ),
                    ],
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        double spending = double.tryParse(value.replaceAll(',', '.')) ?? 0;
                        _addSpending(spending);
                      }
                    },
                  ),
                  
                ),
                ElevatedButton(
                  onPressed: () => _addSpending(0),
                  child: const Icon(Icons.mic),
                )
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showPopupLessZero(context),
              child: const Text('Open Popup Less Zero'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _showPopupUnderLimit(context),
              child: const Text('Open Popup Under Limit'),
            ),
          ],
        ),
      ),
    );
  }
}
