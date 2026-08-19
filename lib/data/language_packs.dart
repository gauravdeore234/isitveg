class LanguagePack {
  final String id;
  final String name;
  final String flag;
  final String region;
  final String scriptId;
  final String description;
  final bool isBundled;
  final int estimatedSizeMb;

  const LanguagePack({
    required this.id,
    required this.name,
    required this.flag,
    required this.region,
    required this.scriptId,
    required this.description,
    required this.isBundled,
    required this.estimatedSizeMb,
  });
}

const List<LanguagePack> availableLanguagePacks = [
  LanguagePack(
    id: 'latin',
    name: 'Latin Script',
    flag: 'ABC',
    region: 'Europe & Americas',
    scriptId: 'latin',
    description:
        'English, French, German, Spanish, Italian, Portuguese, Dutch, Turkish, and more',
    isBundled: true,
    estimatedSizeMb: 0,
  ),
  LanguagePack(
    id: 'chinese',
    name: 'Chinese',
    flag: '🇨🇳',
    region: 'East Asia',
    scriptId: 'chinese',
    description: 'Simplified & Traditional Chinese characters',
    isBundled: false,
    estimatedSizeMb: 4,
  ),
  LanguagePack(
    id: 'japanese',
    name: 'Japanese',
    flag: '🇯🇵',
    region: 'East Asia',
    scriptId: 'japanese',
    description: 'Kanji, Hiragana, and Katakana',
    isBundled: false,
    estimatedSizeMb: 4,
  ),
  LanguagePack(
    id: 'korean',
    name: 'Korean',
    flag: '🇰🇷',
    region: 'East Asia',
    scriptId: 'korean',
    description: 'Korean Hangul script',
    isBundled: false,
    estimatedSizeMb: 3,
  ),
  LanguagePack(
    id: 'devanagari',
    name: 'Devanagari',
    flag: '🇮🇳',
    region: 'South Asia',
    scriptId: 'devanagari',
    description:
        'Hindi, Marathi, Sanskrit, and other Devanagari-based languages',
    isBundled: false,
    estimatedSizeMb: 3,
  ),
];
