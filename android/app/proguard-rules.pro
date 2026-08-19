# ML Kit text recognition ships optional script recognizers (Chinese, Japanese,
# Korean, Devanagari) that this app does not bundle. R8 sees the references but
# not the classes, so tell it not to warn. Latin is bundled and kept as normal.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
