import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';
import '../services/ocr_service.dart';
import '../services/ingredient_analyzer.dart';
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

  /// Height of the control strip + floating nav bar the overlay must clear.
  static const double _controlsInset = 150;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
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
      final text = await _ocrService.recognizeFromPath(path);

      if (text.trim().isEmpty) {
        if (mounted) {
          setState(() => _isProcessing = false);
          _showMessage(
              'No text found. Try moving closer or improving lighting.');
        }
        return;
      }

      final result = _analyzer.analyze(text, imagePath: path);

      if (mounted) {
        setState(() => _isProcessing = false);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        _showMessage('Error: $e');
      }
    }
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
