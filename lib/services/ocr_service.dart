import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Result of an OCR pass: the recognized text plus which script recognizer
/// produced it (so the caller can name the detected language).
class OcrOutcome {
  final RecognizedText text;
  final String scriptId;

  const OcrOutcome(this.text, this.scriptId);

  /// Number of recognized words — a rough "how much did we read" score used to
  /// pick the best recognizer and to tell a real label from OCR noise.
  int get wordCount {
    var n = 0;
    for (final block in text.blocks) {
      for (final line in block.lines) {
        n += line.elements.length;
      }
    }
    return n;
  }
}

class OcrService {
  final Map<String, TextRecognizer> _recognizers = {};

  TextRecognizer _recognizerFor(String scriptId) {
    return _recognizers.putIfAbsent(
      scriptId,
      () => TextRecognizer(script: _scriptFor(scriptId)),
    );
  }

  static TextRecognitionScript _scriptFor(String scriptId) {
    return switch (scriptId) {
      'chinese' => TextRecognitionScript.chinese,
      'japanese' => TextRecognitionScript.japanese,
      'korean' => TextRecognitionScript.korean,
      'devanagari' => TextRecognitionScript.devanagiri,
      _ => TextRecognitionScript.latin,
    };
  }

  /// Reads [imageFile] with the Latin recognizer first (always bundled). If
  /// Latin comes back sparse — the tell-tale of a non-Latin label — it retries
  /// with each [enabledScriptIds] recognizer and keeps whichever read the most.
  /// Running extra recognizers only when Latin fails keeps the common
  /// English-label path fast.
  Future<OcrOutcome> recognizeBest(
    File imageFile, {
    required Iterable<String> enabledScriptIds,
  }) async {
    final input = InputImage.fromFile(imageFile);

    final latin = OcrOutcome(
      await _recognizerFor('latin').processImage(input),
      'latin',
    );
    if (latin.wordCount >= _latinReadableWords) return latin;

    var best = latin;
    for (final scriptId in enabledScriptIds) {
      if (scriptId == 'latin') continue;
      final outcome = OcrOutcome(
        await _recognizerFor(scriptId).processImage(input),
        scriptId,
      );
      if (outcome.wordCount > best.wordCount) best = outcome;
    }
    return best;
  }

  /// A Latin pass with at least this many words is treated as a real,
  /// readable label rather than noise from a non-Latin image.
  static const int _latinReadableWords = 4;

  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.close();
    }
    _recognizers.clear();
  }
}
