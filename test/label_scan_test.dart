import 'dart:math';
import 'dart:ui';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:is_it_veg/models/ingredient.dart';
import 'package:is_it_veg/services/label_scan.dart';

TextElement _element(String text, Rect box) => TextElement(
      text: text,
      symbols: const [],
      boundingBox: box,
      recognizedLanguages: const [],
      cornerPoints: const <Point<int>>[],
      confidence: null,
      angle: null,
    );

RecognizedText _textOf(List<TextElement> elements) {
  final line = TextLine(
    text: elements.map((e) => e.text).join(' '),
    elements: elements,
    boundingBox: const Rect.fromLTWH(0, 0, 100, 20),
    recognizedLanguages: const [],
    cornerPoints: const <Point<int>>[],
    confidence: null,
    angle: null,
  );
  final block = TextBlock(
    text: line.text,
    lines: [line],
    boundingBox: line.boundingBox,
    recognizedLanguages: const [],
    cornerPoints: const <Point<int>>[],
  );
  return RecognizedText(text: block.text, blocks: [block]);
}

FlaggedIngredient _flag(String matchedText, IngredientSeverity severity) =>
    FlaggedIngredient(
      matchedText: matchedText,
      ingredient: Ingredient(
        name: 'Test',
        aliases: const [],
        category: IngredientCategory.meat,
        severity: severity,
        explanation: '',
      ),
      startIndex: 0,
      endIndex: 0,
    );

void main() {
  group('languageName', () {
    test('maps script ids to display names', () {
      expect(languageName('chinese'), 'Chinese');
      expect(languageName('devanagari'), 'Devanagari');
      expect(languageName('latin'), 'Latin');
    });
  });

  group('attachBoxes', () {
    const gelatinBox = Rect.fromLTWH(10, 10, 40, 12);
    final recognized = _textOf([
      _element('gelatin', gelatinBox),
      _element('sugar', const Rect.fromLTWH(60, 10, 30, 12)),
      _element('tamarind', const Rect.fromLTWH(10, 30, 50, 12)),
    ]);

    test('boxes the matched ingredient word', () {
      final result = attachBoxes(recognized, [
        _flag('gelatin', IngredientSeverity.definite),
      ]);
      expect(result.single.boxes, [gelatinBox]);
    });

    test('drops the fuzzy "(likely: x)" suffix when matching', () {
      final result = attachBoxes(recognized, [
        _flag('ge|atin (likely: gelatin)', IngredientSeverity.definite),
      ]);
      // The damaged surface word won't match, but "gelatin" from the suffix
      // hint should not be used to box, so no false box appears here.
      expect(result.single.boxes, isEmpty);
    });

    test('does not box an alias sitting inside a longer word', () {
      // "rind" must not box "tamarind".
      final result = attachBoxes(recognized, [
        _flag('rind', IngredientSeverity.definite),
      ]);
      expect(result.single.boxes, isEmpty);
    });
  });
}
