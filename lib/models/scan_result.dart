import 'ingredient.dart';

enum Verdict {
  vegetarian,
  nonVegetarian,
  uncertain,
}

/// The wording every verdict is presented with. Result screen and history
/// read from here so a scan reads identically wherever it is shown.
extension VerdictCopy on Verdict {
  String get label => switch (this) {
        Verdict.vegetarian => 'Vegetarian',
        Verdict.nonVegetarian => 'Non-Vegetarian',
        Verdict.uncertain => 'Uncertain',
      };

  String get summary => switch (this) {
        Verdict.vegetarian => 'Safe to consume based on scanned ingredients.',
        Verdict.nonVegetarian =>
          'Not safe for vegetarian consumption based on scanned ingredients.',
        Verdict.uncertain =>
          'Some ingredients may be animal-derived. Check flagged items below.',
      };
}

class ScanResult {
  final int? id;
  final String rawText;
  final Verdict verdict;
  final List<FlaggedIngredient> flaggedIngredients;
  final Set<IngredientCategory> categories;
  final DateTime scannedAt;
  final String? imagePath;

  ScanResult({
    this.id,
    required this.rawText,
    required this.verdict,
    required this.flaggedIngredients,
    required this.categories,
    DateTime? scannedAt,
    this.imagePath,
  }) : scannedAt = scannedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'raw_text': rawText,
      'verdict': verdict.index,
      'categories': categories.map((c) => c.index).toList().join(','),
      'scanned_at': scannedAt.toIso8601String(),
      'image_path': imagePath,
      'flagged_json': flaggedIngredients
          .map((f) => '${f.matchedText}|${f.ingredient.name}')
          .toList()
          .join(';;'),
    };
  }

  String get verdictLabel => verdict.label;

  String get verdictSummary => verdict.summary;

  /// Emoji + label pairs shown as chips on the verdict card.
  List<({String emoji, String label})> get categoryChips {
    return categories.map((c) {
      switch (c) {
        case IngredientCategory.meat:
          return (emoji: '\u{1F356}', label: 'Contains Meat');
        case IngredientCategory.poultry:
          return (emoji: '\u{1F357}', label: 'Contains Poultry');
        case IngredientCategory.fish:
          return (emoji: '\u{1F41F}', label: 'Contains Fish');
        case IngredientCategory.egg:
          return (emoji: '\u{1F95A}', label: 'Contains Egg');
        case IngredientCategory.insect:
          return (emoji: '\u{1F41E}', label: 'Insect-Derived');
      }
    }).toList();
  }

  List<String> get categoryLabels {
    return categories.map((c) {
      switch (c) {
        case IngredientCategory.meat:
          return 'Contains Meat';
        case IngredientCategory.poultry:
          return 'Contains Poultry';
        case IngredientCategory.fish:
          return 'Contains Fish';
        case IngredientCategory.egg:
          return 'Contains Egg';
        case IngredientCategory.insect:
          return 'Insect-Derived';
      }
    }).toList();
  }
}
