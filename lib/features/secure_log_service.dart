import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureLogService {
  static final SecureLogService _instance = SecureLogService._internal();
  factory SecureLogService() => _instance;
  SecureLogService._internal();

  final _key = encrypt.Key.fromLength(32); // 256-bit key (trzymaj bezpiecznie!)
  final _iv = encrypt.IV.fromLength(16);   // IV dla AES

  Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/secure_log.txt');
  }

  String _encrypt(String plainText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String _decrypt(String cipherText) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.decrypt64(cipherText, iv: _iv);
  }

  Future<void> saveValue(
    String time,
    String spending,
    String budgetAfter,
    String limitLeft) async {
    final now = DateTime.now().toIso8601String();
    final logEntry = jsonEncode({
      'time': now,
      'spending': spending,
      'budget after': budgetAfter,
      'limit left': limitLeft});
    final encrypted = _encrypt(logEntry);

    final file = await _getLogFile();
    await file.writeAsString('$encrypted\n', mode: FileMode.append);
  }

  Future<List<Map<String, dynamic>>> readAllValues() async {
    final file = await _getLogFile();
    if (!await file.exists()) return [];

    final lines = await file.readAsLines();
    return lines.map((line) {
      try {
        final decrypted = _decrypt(line);
        return jsonDecode(decrypted);
      } catch (_) {
        return null;
      }
    }).whereType<Map<String, dynamic>>().toList();
  }
}
