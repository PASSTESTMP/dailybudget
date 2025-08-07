import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _speech = SpeechToText();
  bool _isAvailable = false;
  bool _isListening = false;
  String _lastResult = '';

  Future<bool> initialize() async {
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  bool get isAvailable => _isAvailable;
  bool get isListening => _isListening;
  String get lastResult => _lastResult;

  Future<void> startListening({
    void Function(String)? onResult,
    String localeId = 'pl_PL',
  }) async {
    if (!_isAvailable) return;
    _isListening = true;
    await _speech.listen(
      onResult: (result) {
        _lastResult = result.recognizedWords;
        if (onResult != null) onResult(_lastResult);
      },
      localeId: localeId,
    );
  }

  Future<void> stopListening() async {
    if (!_isListening) return;
    await _speech.stop();
    _isListening = false;
  }

  void dispose() {
    _speech.cancel();
  }
}