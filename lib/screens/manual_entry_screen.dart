import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/theme.dart';
import '../services/ingredient_analyzer.dart';
import '../widgets/app_top_bar.dart';
import 'result_screen.dart';

class ManualEntryScreen extends StatefulWidget {
  final String? initialText;
  const ManualEntryScreen({super.key, this.initialText});

  @override
  State<ManualEntryScreen> createState() => _ManualEntryScreenState();
}

class _ManualEntryScreenState extends State<ManualEntryScreen> {
  late final TextEditingController _controller;
  final _analyzer = IngredientAnalyzer();
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _controller.text = data!.text!;
      _controller.selection =
          TextSelection.collapsed(offset: _controller.text.length);
    }
  }

  void _analyze() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter ingredients first')),
      );
      return;
    }
    setState(() => _isAnalyzing = true);
    final result = _analyzer.analyze(text);
    setState(() => _isAnalyzing = false);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppTopBar.back(context),
      body: AppContentCanvas(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Type or paste the ingredient list below to check for non-vegan additives.',
                style: AppText.bodyLg(palette.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: AppText.bodyLg(palette.onSurface),
                        decoration: const InputDecoration(
                          hintText:
                              'e.g., Water, Sugar, Enriched Flour, Red 40, Natural Flavors...',
                          hintMaxLines: 3,
                          contentPadding: EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            AppSpacing.md,
                            AppSpacing.md,
                            56,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: AppSpacing.md,
                      right: AppSpacing.md,
                      child: _PasteButton(onTap: _paste),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyze,
                icon: _isAnalyzing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: palette.onPrimaryContainer,
                        ),
                      )
                    : const Icon(Icons.search, size: 22),
                label: Text(_isAnalyzing ? 'ANALYZING…' : 'CHECK INGREDIENTS'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasteButton extends StatelessWidget {
  final VoidCallback onTap;
  const _PasteButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.full),
      elevation: 1,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.base,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(color: palette.outlineVariant),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.content_paste, size: 16, color: palette.primary),
              const SizedBox(width: AppSpacing.xs),
              Text('PASTE', style: AppText.labelCaps(palette.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
