import 'dart:ui' show Rect;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../models/ingredient.dart';

/// Human-readable name for a recognizer script id, used when telling the user
/// which language a label appears to be in.
String languageName(String scriptId) {
  return switch (scriptId) {
    'chinese' => 'Chinese',
    'japanese' => 'Japanese',
    'korean' => 'Korean',
    'devanagari' => 'Devanagari',
    _ => 'Latin',
  };
}

/// Returns each flagged ingredient with the bounding boxes of its words in the
/// image attached, so the result screen can outline them on the photo. Matches
/// on whole words to avoid boxing an alias that merely sits inside a longer,
/// unrelated word.
List<FlaggedIngredient> attachBoxes(
  RecognizedText recognized,
  List<FlaggedIngredient> flagged,
) {
  final elements = <({String text, Rect box})>[];
  for (final block in recognized.blocks) {
    for (final line in block.lines) {
      for (final element in line.elements) {
        elements.add((text: element.text.toLowerCase(), box: element.boundingBox));
      }
    }
  }

  return flagged.map((f) {
    final words = _highlightWords(f.matchedText);
    if (words.isEmpty) return f;

    final boxes = <Rect>[];
    for (final e in elements) {
      if (words.any((w) => _containsWord(e.text, w))) boxes.add(e.box);
    }
    return boxes.isEmpty ? f : f.withBoxes(boxes);
  }).toList();
}

/// The words to outline for a match. Drops the "(likely: x)" fuzzy suffix and
/// keeps tokens long enough to be distinctive.
Set<String> _highlightWords(String matchedText) {
  final core = matchedText.replaceAll(RegExp(r'\(likely:.*\)'), '');
  return RegExp(r'[a-z]{3,}')
      .allMatches(core.toLowerCase())
      .map((m) => m.group(0)!)
      .toSet();
}

bool _containsWord(String haystack, String word) {
  return RegExp('\\b${RegExp.escape(word)}\\b').hasMatch(haystack);
}
