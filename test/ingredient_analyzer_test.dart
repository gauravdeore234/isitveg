import 'package:flutter_test/flutter_test.dart';
import 'package:is_it_veg/services/ingredient_analyzer.dart';
import 'package:is_it_veg/models/scan_result.dart';
import 'package:is_it_veg/models/ingredient.dart';

void main() {
  late IngredientAnalyzer analyzer;

  setUp(() {
    analyzer = IngredientAnalyzer();
  });

  group('Verdict: Vegetarian', () {
    test('all safe ingredients returns vegetarian', () {
      const text =
          'Sugar, wheat flour, cocoa butter, soy lecithin, vanilla extract, citric acid, pectin';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.vegetarian);
      expect(result.flaggedIngredients, isEmpty);
    });

    test('agar-agar is not flagged (safe false positive)', () {
      const text = 'Sugar, agar-agar, fruit juice, citric acid';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.vegetarian);
    });

    test('soy lecithin is not flagged', () {
      const text = 'Cocoa mass, sugar, soy lecithin (E322)';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.vegetarian);
    });

    test('empty text returns vegetarian with no flags', () {
      final result = analyzer.analyze('');
      expect(result.verdict, Verdict.vegetarian);
      expect(result.flaggedIngredients, isEmpty);
    });
  });

  group('Verdict: Non-Vegetarian', () {
    test('gelatin is flagged as non-veg', () {
      const text = 'Sugar, glucose syrup, gelatin, citric acid, colors';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(
          result.flaggedIngredients.any(
            (f) => f.ingredient.name == 'Gelatin',
          ),
          isTrue);
    });

    test('gelatine (European spelling) is flagged', () {
      const text = 'Sucre, sirop de glucose, gélatine, acide citrique';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
    });

    test('anchovy in Worcestershire sauce detected', () {
      const text =
          'Malt vinegar, molasses, sugar, salt, anchovies, tamarind extract, spices';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.fish));
    });

    test('E120 (carmine) flagged as insect-derived', () {
      const text = 'Sugar, water, E120, citric acid, raspberry flavour';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.insect));
    });

    test('E441 flagged as meat-derived gelatin', () {
      const text = 'Sugar, modified starch, E441, natural flavouring';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
    });

    test('chicken stock detected', () {
      const text = 'Water, noodles, chicken stock, salt, spices, yeast extract';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.poultry));
    });

    test('lard detected (English)', () {
      const text = 'Wheat flour, lard, salt, baking powder';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.meat));
    });

    test('Schweineschmalz (German for lard) detected', () {
      const text = 'Weizenmehl, Schweineschmalz, Salz, Backpulver';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
    });

    test('egg albumin detected', () {
      const text = 'Wheat flour, sugar, butter, albumin, vanilla';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.egg));
    });

    test('shellac (E904) detected as insect-derived', () {
      const text = 'Dark chocolate, sugar, cocoa butter, E904, soy lecithin';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(result.categories, contains(IngredientCategory.insect));
    });

    test('multiple non-veg items — all categories captured', () {
      const text = 'Gelatin, E120, albumin, chicken fat, anchovy extract';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
      expect(
          result.categories,
          containsAll([
            IngredientCategory.meat,
            IngredientCategory.egg,
            IngredientCategory.insect,
            IngredientCategory.poultry,
            IngredientCategory.fish,
          ]));
    });
  });

  group('Verdict: Uncertain', () {
    test('E471 alone returns uncertain', () {
      const text = 'Wheat flour, sugar, palm oil, E471, salt';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.uncertain);
    });

    test('natural flavoring returns uncertain', () {
      const text = 'Water, sugar, natural flavoring, citric acid';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.uncertain);
    });

    test('lecithin (unspecified) returns uncertain', () {
      const text = 'Cocoa mass, sugar, cocoa butter, lecithin, vanilla';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.uncertain);
    });
  });

  group('Edge cases', () {
    test('OCR-typical noise handled gracefully', () {
      const text =
          'INGRED|ENTS: Sugar, wheat f|our, coca butter, ge|atin, sa|t';
      expect(() => analyzer.analyze(text), returnsNormally);
    });

    test('parenthetical sub-ingredients parsed', () {
      const text =
          'Chocolate (sugar, cocoa butter, gelatin), wheat flour, salt';
      final result = analyzer.analyze(text);
      expect(result.verdict, Verdict.nonVegetarian);
    });

    test('no duplicates when same ingredient appears twice', () {
      const text = 'Gelatin, sugar, more gelatin, water';
      final result = analyzer.analyze(text);
      final gelatinMatches = result.flaggedIngredients
          .where((f) => f.ingredient.name == 'Gelatin')
          .length;
      expect(gelatinMatches, equals(1));
    });
  });
}
