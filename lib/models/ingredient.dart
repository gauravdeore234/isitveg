import 'dart:ui' show Rect;

enum IngredientCategory {
  meat,
  poultry,
  fish,
  egg,
  insect,
}

enum IngredientSeverity {
  definite,
  possible,
  safe,
}

class Ingredient {
  final String name;
  final List<String> aliases;
  final IngredientCategory category;
  final IngredientSeverity severity;
  final String explanation;

  const Ingredient({
    required this.name,
    required this.aliases,
    required this.category,
    required this.severity,
    required this.explanation,
  });
}

class FlaggedIngredient {
  final String matchedText;
  final Ingredient ingredient;
  final int startIndex;
  final int endIndex;

  /// Bounding boxes of this ingredient's words in the scanned image, in image
  /// pixel coordinates. Empty for manual entries and reopened history scans
  /// (which are re-analyzed from stored text, not the image).
  final List<Rect> boxes;

  const FlaggedIngredient({
    required this.matchedText,
    required this.ingredient,
    required this.startIndex,
    required this.endIndex,
    this.boxes = const [],
  });

  FlaggedIngredient withBoxes(List<Rect> boxes) => FlaggedIngredient(
        matchedText: matchedText,
        ingredient: ingredient,
        startIndex: startIndex,
        endIndex: endIndex,
        boxes: boxes,
      );
}
