import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/language_packs.dart';

class LanguagePackService {
  static const String _prefKey = 'downloaded_packs';

  Future<Set<String>> getDownloadedPacks() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefKey) ?? ['latin'];
    return list.toSet();
  }

  Future<void> _savePacks(Set<String> packs) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, packs.toList());
  }

  Future<void> downloadPack(
    LanguagePack pack, {
    void Function(double progress)? onProgress,
  }) async {
    // For non-Latin scripts, ML Kit downloads the model on first use when
    // you instantiate TextRecognizer with the appropriate script.
    // We simulate the download here and persist the state.
    // In production, wire up google_mlkit_commons ModelManager for real
    // progress events.
    if (pack.isBundled) return;

    const steps = 10;
    for (var i = 1; i <= steps; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      onProgress?.call(i / steps);
    }

    final packs = await getDownloadedPacks();
    packs.add(pack.id);
    await _savePacks(packs);
  }

  Future<void> removePack(LanguagePack pack) async {
    if (pack.isBundled) return;
    final packs = await getDownloadedPacks();
    packs.remove(pack.id);
    await _savePacks(packs);
  }

  TextRecognitionScript scriptForPackId(String packId) {
    return switch (packId) {
      'chinese' => TextRecognitionScript.chinese,
      'japanese' => TextRecognitionScript.japanese,
      'korean' => TextRecognitionScript.korean,
      'devanagari' => TextRecognitionScript.devanagiri,
      _ => TextRecognitionScript.latin,
    };
  }
}
