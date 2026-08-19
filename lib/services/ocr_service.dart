import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  TextRecognizer? _recognizer;
  TextRecognitionScript _currentScript = TextRecognitionScript.latin;

  TextRecognizer get recognizer {
    _recognizer ??= TextRecognizer(script: _currentScript);
    return _recognizer!;
  }

  void setScript(TextRecognitionScript script) {
    if (script != _currentScript) {
      _recognizer?.close();
      _recognizer = null;
      _currentScript = script;
    }
  }

  Future<String> recognizeFromFile(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final result = await recognizer.processImage(inputImage);
    return result.text;
  }

  Future<String> recognizeFromPath(String path) async {
    return recognizeFromFile(File(path));
  }

  Future<RecognizedText> recognizeDetailed(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    return recognizer.processImage(inputImage);
  }

  void dispose() {
    _recognizer?.close();
  }
}
