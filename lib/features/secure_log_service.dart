import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class SecureLogService {
  static final SecureLogService _instance = SecureLogService._internal();
  factory SecureLogService() => _instance;
  SecureLogService._internal();

  
  late encrypt.Key _key;
  late encrypt.IV _iv;

  Future<void> initKeyAndIV() async {
    final prefs = await SharedPreferences.getInstance();

    String? keyBase64 = prefs.getString('aes_key');
    String? ivBase64 = prefs.getString('aes_iv');

    if (keyBase64 == null || ivBase64 == null) {
      // Pierwsze uruchomienie → generujemy losowe wartości
      final newKey = encrypt.Key.fromSecureRandom(32); // 256-bit
      final newIv = encrypt.IV.fromSecureRandom(16);   // 128-bit

      // Zapis w base64
      await prefs.setString('aes_key', newKey.base64);
      await prefs.setString('aes_iv', newIv.base64);

      _key = newKey;
      _iv = newIv;
    } else {
      // Odczyt zapisanych wartości
      _key = encrypt.Key.fromBase64(keyBase64);
      _iv = encrypt.IV.fromBase64(ivBase64);
    }
  }


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

  String _prepareTimestamp(DateTime dt){
    return "${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}:${dt.second}";
  }

  Future<void> saveValue(
    String time,
    String spending,
    String budgetAfter,
    String limitLeft) async {
    final now = _prepareTimestamp(DateTime.now());
    final logEntry = jsonEncode({
      'time': now,
      'spending': double.parse(spending).toStringAsFixed(2),
      'budget after': double.parse(budgetAfter).toStringAsFixed(2),
      'limit left': double.parse(limitLeft).toStringAsFixed(2)});
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
