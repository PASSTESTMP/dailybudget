import 'package:dailybudget/features/secure_log_service.dart';
import 'package:dailybudget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  String _lines = "";
  List<String> _headder = [];
  List<Map<String, dynamic>> _rows = [];
  

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      final secureLog = SecureLogService();
      final logs = await secureLog.readAllValues().timeout(Duration(seconds: 5));
      setState(() {
        _rows = logs;
        _headder = logs.first.keys.toList();
      });
    } catch (e) {
      setState(() {
        _lines = 'Error loading file: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.logViewer)),
      body: _headder.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: _lines != ""
              ? Text(_lines)
              : DataTable(
                columns: _headder
                  .map((key) => DataColumn(label: Text(key)))
                  .toList(),
                rows: _rows.map((row) {
                  return DataRow(
                    cells: _headder.map((col) {
                      return DataCell(Text('${row[col] ?? ''}'));
                    }).toList(),
                  );
                }).toList().reversed.toList(),
              )
              
              // ListView.builder(
              //   itemCount: _lines.length,
              //   itemExtent: 48, // Approximate height for 10 lines on screen
              //   physics: const ClampingScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //       dense: true,
              //       title: Text(
              //         _lines[index],
              //         style: const TextStyle(fontFamily: 'monospace'),
              //       ),
              //     );
              //   },
              // ),
            ),
    );
  }
}