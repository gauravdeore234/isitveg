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

  const FlaggedIngredient({
    required this.matchedText,
    required this.ingredient,
    required this.startIndex,
    required this.endIndex,
  });
}
