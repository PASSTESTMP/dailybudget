import 'dart:convert';
import 'package:dailybudget/features/secure_log_service.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  List<String> _lines = [];
  

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
        _lines = logs.map((e) => jsonEncode(e)).toList();
      });
    } catch (e) {
      setState(() {
        _lines = ['Error loading file: $e'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log Viewer')),
      body: _lines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.builder(
                itemCount: _lines.length,
                itemExtent: 48, // Approximate height for 10 lines on screen
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    dense: true,
                    title: Text(
                      _lines[index],
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}