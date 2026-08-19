import '../data/ingredient_database.dart';
import '../models/ingredient.dart';
import '../models/scan_result.dart';

class IngredientAnalyzer {
  final IngredientDatabase _db = IngredientDatabase();

  static final RegExp _eNumberRegex = RegExp(
    r'\be\s*(\d{3,4}[a-g]?)\b',
    caseSensitive: false,
  );

  ScanResult analyze(String rawText, {String? imagePath}) {
    final cleaned = _cleanText(rawText);
    final flagged = <FlaggedIngredient>[];
    final seen = <String>{};

    void add(FlaggedIngredient candidate) {
      if (seen.add(candidate.ingredient.name)) flagged.add(candidate);
    }

    for (final segment in _segments(cleaned)) {
      if (segment.name.isEmpty) continue;

      // A safe declaration suppresses the whole segment, including any
      // E-number inside it: "soy lecithin (E322)" names a plant source,
      // so the bare E322 should not be reported as possibly egg-derived.
      if (_db.isSafeFalsePositive(segment.name)) continue;

      final match = _matchToken(segment.name, cleaned);
      if (match != null) add(match);

      for (final match in _eNumberRegex.allMatches(segment.text)) {
        final ingredient = _db.exactMatch('e${match.group(1)!.toLowerCase()}');
        if (ingredient == null) continue;
        add(FlaggedIngredient(
          matchedText: match.group(0)!,
          ingredient: ingredient,
          startIndex: segment.start + match.start,
          endIndex: segment.start + match.end,
        ));
      }
    }

    final categories = flagged.map((f) => f.ingredient.category).toSet();

    final hasDefinite = flagged.any(
      (f) => f.ingredient.severity == IngredientSeverity.definite,
    );
    final hasPossible = flagged.any(
      (f) => f.ingredient.severity == IngredientSeverity.possible,
    );

    Verdict verdict;
    if (hasDefinite) {
      verdict = Verdict.nonVegetarian;
    } else if (hasPossible) {
      verdict = Verdict.uncertain;
    } else {
      verdict = Verdict.vegetarian;
    }

    return ScanResult(
      rawText: rawText,
      verdict: verdict,
      flaggedIngredients: flagged,
      categories: categories,
      imagePath: imagePath,
    );
  }

  String _cleanText(String text) {
    var cleaned = text.toLowerCase();
    cleaned = cleaned.replaceAll(RegExp(r'[|]'), 'i');
    cleaned = cleaned.replaceAll(RegExp(r'[\n\r]+'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'["""]'), '"');
    cleaned = cleaned.replaceAll(RegExp(r"[''']"), "'");
    return cleaned.trim();
  }

  /// Splits a label into comma/semicolon-separated declarations, keeping both
  /// the original text (brackets included) and the bare ingredient name.
  List<_Segment> _segments(String text) {
    final segments = <_Segment>[];
    var start = 0;

    void take(int end) {
      final raw = text.substring(start, end);
      final trimmed = raw.trim();
      if (trimmed.isNotEmpty) {
        segments.add(_Segment(
          text: trimmed,
          name: _stripBrackets(trimmed),
          start: start + raw.indexOf(trimmed),
        ));
      }
    }

    for (var i = 0; i < text.length; i++) {
      if (text[i] == ',' || text[i] == ';') {
        take(i);
        start = i + 1;
      }
    }
    take(text.length);

    return segments;
  }

  String _stripBrackets(String text) {
    return text
        .replaceAll(RegExp(r'\([^)]*\)'), ' ')
        .replaceAll(RegExp(r'\[[^\]]*\]'), ' ')
        // Splitting on commas cuts bracketed sub-lists in half, leaving a
        // dangling bracket on the name ("soy lecithin)") that would otherwise
        // miss both the safe list and the exact-match lookup.
        .replaceAll(RegExp(r'[()\[\]]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  FlaggedIngredient? _matchToken(String token, String fullText) {
    final lower = token.toLowerCase().trim();

    if (_db.isSafeFalsePositive(lower)) return null;

    FlaggedIngredient make(Ingredient ingredient, String matched) {
      final idx = fullText.indexOf(lower);
      return FlaggedIngredient(
        matchedText: matched,
        ingredient: ingredient,
        startIndex: idx >= 0 ? idx : 0,
        endIndex: idx >= 0 ? idx + lower.length : lower.length,
      );
    }

    final exact = _db.exactMatch(lower);
    if (exact != null) return make(exact, token);

    final substring = _db.substringMatch(lower);
    if (substring != null) return make(substring, token);

    if (lower.length >= 5) {
      final fuzzy = _fuzzyMatch(lower);
      if (fuzzy != null) return make(fuzzy, '$token (likely: ${fuzzy.name})');
    }

    return null;
  }

  /// Recovers OCR damage ("ge|atin" -> "gelatin") without inventing matches.
  /// The edit budget scales with alias length: short aliases are only matched
  /// on a single typo, because at two edits everyday words collide with them
  /// (e.g. "sugar" is two edits from "sugna", an Italian alias for lard).
  Ingredient? _fuzzyMatch(String text) {
    Ingredient? bestMatch;
    var bestDistance = 3;

    for (final ingredient in _db.allIngredients) {
      for (final alias in ingredient.aliases) {
        if (alias.length < 5) continue;
        if ((alias.length - text.length).abs() > 2) continue;

        final budget = alias.length >= 8 ? 2 : 1;
        final distance = _levenshtein(text, alias);
        if (distance <= budget && distance < bestDistance) {
          bestDistance = distance;
          bestMatch = ingredient;
        }
      }
    }

    return bestMatch;
  }

  int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final matrix = List.generate(
      a.length + 1,
      (i) => List.generate(b.length + 1, (j) => 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }
    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[a.length][b.length];
  }
}

class _Segment {
  final String text;
  final String name;
  final int start;

  const _Segment({required this.text, required this.name, required this.start});
}
