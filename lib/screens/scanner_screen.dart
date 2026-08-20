import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';
import '../services/ocr_service.dart';
import '../services/ingredient_analyzer.dart';
import '../services/label_scan.dart';
import '../services/language_pack_service.dart';
import '../widgets/camera_overlay.dart';
import 'result_screen.dart';
import 'manual_entry_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  final OcrService _ocrService = OcrService();
  final IngredientAnalyzer _analyzer = IngredientAnalyzer();
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  bool _isCameraReady = false;
  bool _torchOn = false;
  String? _error;

  /// Scripts the user has enabled in Settings; drives which OCR recognizers a
  /// non-Latin label is retried against. Latin is always available.
  Set<String> _enabledScripts = {'latin'};

  /// A Latin pass with fewer real words than this is treated as an unreadable
  /// (likely non-Latin) label rather than a genuine ingredient list, so we warn
  /// instead of defaulting to a false "Vegetarian" verdict.
  static const int _minReadableWords = 3;

  /// Height of the control strip + floating nav bar the overlay must clear.
  static const double _controlsInset = 150;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
    _loadEnabledScripts();
  }

  Future<void> _loadEnabledScripts() async {
    final packs = await LanguagePackService().getDownloadedPacks();
    if (mounted) setState(() => _enabledScripts = packs);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    _ocrService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = 'No camera found');
        return;
      }

      final camera = cameras.first;
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraReady = true;
          _torchOn = false;
          _error = null;
        });
      }
    } catch (e) {
      setState(() => _error = 'Camera error: $e');
    }
  }

  Future<void> _toggleTorch() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      final next = !_torchOn;
      await controller.setFlashMode(next ? FlashMode.torch : FlashMode.off);
      if (mounted) setState(() => _torchOn = next);
    } catch (_) {
      if (mounted) _showMessage('Torch not available on this device.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _analyzeImage(String path) async {
    try {
      final file = File(path);
      final outcome = await _ocrService.recognizeBest(
        file,
        enabledScriptIds: _enabledScripts,
      );
      final text = outcome.text.text;

      // A non-Latin recognizer read the label better than Latin: we know the
      // script but the ingredient database is English-only, so we must not
      // guess a verdict — name the language and send the user to Manual entry.
      if (outcome.scriptId != 'latin') {
        _stopProcessing();
        _showLanguageBlock(scriptId: outcome.scriptId);
        return;
      }

      // Empty or sparse Latin output means either a blank/blurry shot or a
      // label in a script we can't read. Either way, warn instead of defaulting
      // to a false "Vegetarian" verdict.
      if (_wordCount(text) < _minReadableWords) {
        _stopProcessing();
        _showLanguageBlock(scriptId: null);
        return;
      }

      final analyzed = _analyzer.analyze(text, imagePath: path);
      final imageSize = await _decodeSize(file);
      final flagged = attachBoxes(outcome.text, analyzed.flaggedIngredients);

      final result = ScanResult(
        rawText: analyzed.rawText,
        verdict: analyzed.verdict,
        flaggedIngredients: flagged,
        categories: analyzed.categories,
        imagePath: path,
        imageSize: imageSize,
      );

      if (mounted) {
        _stopProcessing();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      _stopProcessing();
      if (mounted) _showMessage('Error: $e');
    }
  }

  void _stopProcessing() {
    if (mounted) setState(() => _isProcessing = false);
  }

  int _wordCount(String text) =>
      RegExp(r'[a-zA-Z]{3,}').allMatches(text).length;

  Future<ui.Size?> _decodeSize(File file) async {
    try {
      final decoded = await decodeImageFromList(await file.readAsBytes());
      final size = ui.Size(
        decoded.width.toDouble(),
        decoded.height.toDouble(),
      );
      decoded.dispose();
      return size;
    } catch (_) {
      return null;
    }
  }

  /// Shown when a label can't be verified: either a detected non-Latin
  /// [scriptId] (named for the user) or, when null, an unreadable label that
  /// may be in a script whose pack isn't enabled.
  void _showLanguageBlock({required String? scriptId}) {
    final lang = scriptId == null ? null : languageName(scriptId);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang != null ? '$lang label detected' : "Couldn't read label"),
        content: Text(
          lang != null
              ? 'This looks like a $lang label. Ingredient checking for $lang '
                  "isn't available yet — please type the ingredients using "
                  'Manual entry.'
              : "Couldn't read the ingredients. Move closer or improve lighting "
                  'and try again. If the label is in another language (Chinese, '
                  'Japanese, Korean, Hindi…), download that language pack in '
                  'Settings, or use Manual entry.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _openManualEntry();
            },
            child: const Text('Manual entry'),
          ),
        ],
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_isProcessing ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final image = await _controller!.takePicture();
      await _analyzeImage(image.path);
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showMessage('Error: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isProcessing = true);
    await _analyzeImage(picked.path);
  }

  void _openManualEntry() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ManualEntryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    // SizedBox.expand: IndexedStack hands its children loose constraints, and
    // a bare Stack would then shrink-wrap to its largest non-positioned child.
    return SizedBox.expand(
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_isCameraReady && _controller != null)
              CameraViewport(controller: _controller!)
            else if (_error != null)
              _CameraError(message: _error!, onRetry: _initCamera)
            else
              const Center(child: CircularProgressIndicator()),

            if (_isCameraReady)
              const CameraOverlay(bottomInset: _controlsInset),

            // Manual-entry pill, top right
            Positioned(
              top: topInset + AppSpacing.lg,
              right: AppSpacing.md,
              child: _ManualPill(onTap: _openManualEntry),
            ),

            // Capture / gallery / torch controls
            Positioned(
              left: 0,
              right: 0,
              bottom: AppSpacing.lg,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _CanvasControl(
                      icon: Icons.image_outlined,
                      label: 'Gallery',
                      onTap: _pickFromGallery,
                    ),
                    _CaptureButton(
                      isProcessing: _isProcessing,
                      onTap: _captureAndAnalyze,
                    ),
                    _CanvasControl(
                      icon: _torchOn
                          ? Icons.flashlight_on
                          : Icons.flashlight_on_outlined,
                      label: 'Torch',
                      filled: true,
                      active: _torchOn,
                      onTap: _toggleTorch,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManualPill extends StatelessWidget {
  final VoidCallback onTap;
  const _ManualPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceContainerLowest.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.keyboard_alt_outlined,
                  size: 18, color: AppColors.onSurface),
              const SizedBox(width: AppSpacing.base),
              Text('Manual', style: AppText.labelCaps(AppColors.onSurface)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CanvasControl extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool filled;
  final bool active;
  final VoidCallback onTap;

  const _CanvasControl({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final background = filled
        ? (active ? AppColors.primaryFixed : Colors.white)
        : AppColors.surfaceContainerHighest.withValues(alpha: 0.3);
    final foreground = filled ? AppColors.onSurfaceVariant : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: filled
                  ? null
                  : Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, size: 24, color: foreground),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        Text(label, style: AppText.labelCaps(Colors.white)),
      ],
    );
  }
}

class _CaptureButton extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback onTap;

  const _CaptureButton({required this.isProcessing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isProcessing ? null : onTap,
      child: Container(
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isProcessing ? AppColors.outline : AppColors.primaryContainer,
          ),
          child: isProcessing
              ? const Padding(
                  padding: EdgeInsets.all(18),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Icon(Icons.document_scanner,
                  color: Colors.white, size: 30),
        ),
      ),
    );
  }
}

class _CameraError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CameraError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_camera_outlined,
                size: 64, color: Colors.white54),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppText.bodySm(Colors.white70),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: 160,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text('RETRY'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
