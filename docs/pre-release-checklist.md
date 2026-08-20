# Pre-Release Checklist — IsItVeg

Run through this before every Play Store push. Test on a **release build**
(`flutter build appbundle --release`) installed on a real device, not just the
debug emulator — several bugs (R8 crashes, signing) only appear in release.

## Automated (must pass)

- [ ] `flutter analyze` — no issues
- [ ] `flutter test` — all tests green
- [ ] Version bumped in `pubspec.yaml` (`versionCode` must be higher than the
      last uploaded build, or Play rejects it)

## Ingredient matching (the core feature)

- [ ] **Non-veg** label flags correctly (e.g. "gelatin", "beef stock")
- [ ] **Veg** label shows green with no false flags
- [ ] **Uncertain** label (e.g. "natural flavouring", bare "E322") shows amber
- [ ] **No false positives inside longer words** — "tamarind" must NOT flag beef
      ("rind"), "reveal" must NOT flag veal. (Regression: substring matcher.)
- [ ] Safe declarations suppress flags — "soy lecithin (E322)" stays veg
- [ ] OCR noise handled — pipe-for-i, broken brackets, extra spaces don't crash

## Scan flows

- [ ] **Camera scan** → result screen shows correct verdict
- [ ] **Gallery upload** → result screen shows verdict (do NOT crash — R8 broke
      this once; keep minify off or crash-test every release)
- [ ] **Manual entry** → paste text → correct verdict
- [ ] **Edit extracted text** → re-analyze reflects the edit

## History

- [ ] After a scan, switch to **History tab** → the new scan appears
      (Regression: IndexedStack keeps the tab alive; it must reload on select.)
- [ ] Tap a history item → reopens the same result (no duplicate saved)
- [ ] Swipe to delete removes the item
- [ ] "Clear all" empties the list, shows empty state

## Permissions

- [ ] First camera use shows the OS permission dialog; granting it works
- [ ] Denying camera still lets Manual entry / Gallery work
- [ ] Gallery pick requests photo permission and succeeds

## UI

- [ ] **Dark mode** — verdict badges, cards, and text are all readable
      (Regression: hardcoded colors ignored the theme once)
- [ ] Onboarding shows on fresh install, not on subsequent launches
- [ ] Long ingredient lists scroll; long product names ellipsize (no overflow)

## Release build specifics

- [ ] AAB is **under 150 MB** (strip native symbols via
      `ndk.debugSymbolLevel = "none"`)
- [ ] AAB signature is the Gradle signingConfig one — do NOT manually
      re-zip/re-sign, Play rejects jarsigner v1 signatures
- [ ] Fresh install from the Play test track launches without crashing
