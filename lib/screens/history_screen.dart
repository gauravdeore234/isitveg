import 'dart:io';
import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';
import '../services/history_service.dart';
import '../services/ingredient_analyzer.dart';
import '../widgets/app_info.dart';
import '../widgets/app_top_bar.dart';
import 'result_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final items = await _historyService.getHistory();
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  /// Rebuilds the scan by re-running the analyzer over the stored text, so
  /// the reopened screen is the same one that appeared right after scanning.
  Future<void> _openItem(Map<String, dynamic> item) async {
    final rawText = (item['raw_text'] as String?) ?? '';
    final imagePath = item['image_path'] as String?;
    final analyzed =
        IngredientAnalyzer().analyze(rawText, imagePath: imagePath);

    final result = ScanResult(
      id: item['id'] as int?,
      rawText: analyzed.rawText,
      verdict: analyzed.verdict,
      flaggedIngredients: analyzed.flaggedIngredients,
      categories: analyzed.categories,
      scannedAt: DateTime.parse(item['scanned_at'] as String),
      imagePath: imagePath,
    );

    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ResultScreen(result: result, saveToHistory: false),
    ));
    if (mounted) _loadHistory();
  }

  Future<void> _deleteItem(int id) async {
    await _historyService.deleteScan(id);
    _loadHistory();
  }

  Future<void> _clearAll() async {
    final palette = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Delete all scan history? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: palette.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _historyService.clearHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Scaffold(
      appBar: AppTopBar(
        leading: AppBarIconButton(
          icon: Icons.menu,
          tooltip: 'Menu',
          onPressed: () => showAppMenu(context),
        ),
        actions: [
          AppBarIconButton(
            icon: Icons.account_circle_outlined,
            tooltip: 'About IsItVeg',
            onPressed: () => showAboutApp(context),
          ),
        ],
      ),
      body: AppContentCanvas(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? const _EmptyState()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.containerMargin,
                          AppSpacing.md,
                          AppSpacing.containerMargin,
                          AppSpacing.md,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Recent Scans',
                                overflow: TextOverflow.ellipsis,
                                style: AppText.titleLg(palette.onSurface),
                              ),
                            ),
                            TextButton(
                              onPressed: _clearAll,
                              child: const Text('Clear all'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadHistory,
                          child: ListView.separated(
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.containerMargin,
                              0,
                              AppSpacing.containerMargin,
                              AppSpacing.lg,
                            ),
                            itemCount: _items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.sm),
                            itemBuilder: (context, index) {
                              final item = _items[index];
                              return Dismissible(
                                key: Key(item['id'].toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (_) =>
                                    _deleteItem(item['id'] as int),
                                background: Container(
                                  padding: const EdgeInsets.only(
                                      right: AppSpacing.lg),
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    color: palette.error,
                                    borderRadius:
                                        BorderRadius.circular(AppRadius.sm),
                                  ),
                                  child: Icon(Icons.delete,
                                      color: palette.onError),
                                ),
                                child: _HistoryCard(
                                  item: item,
                                  onTap: () => _openItem(item),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: palette.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history,
                  size: 32, color: palette.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No scans yet', style: AppText.titleLg(palette.onSurface)),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: Text(
                'Your scan history will appear here once you start checking ingredients.',
                textAlign: TextAlign.center,
                style: AppText.bodySm(palette.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _HistoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final verdict = Verdict.values[item['verdict'] as int];
    final scannedAt = DateTime.parse(item['scanned_at'] as String);
    final imagePath = item['image_path'] as String?;

    final (dotColor, textColor) = switch (verdict) {
      Verdict.vegetarian => (palette.primary, palette.primary),
      Verdict.nonVegetarian => (palette.error, palette.error),
      Verdict.uncertain => (AppColors.tertiaryFixedDim, palette.tertiary),
    };

    // Vegetarian scans have nothing to flag, so they keep the reassuring
    // summary. Non-veg / uncertain scans instead name the problematic
    // ingredients, which is what the user actually needs at a glance.
    final subtitle = verdict == Verdict.vegetarian
        ? verdict.summary
        : _flaggedNames(item['flagged_json'] as String?) ?? verdict.summary;

    final hasThumbnail = imagePath != null && File(imagePath).existsSync();

    return Material(
      color: palette.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: palette.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 12,
                height: 12,
                margin: const EdgeInsets.only(top: 4),
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: Text(
                            verdict.label,
                            style: AppText.bodyLg(textColor)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.base),
                        Text(
                          _formatTimeAgo(scannedAt),
                          style: AppText.bodySm(palette.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.bodySm(palette.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (hasThumbnail) ...[
                const SizedBox(width: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    border: Border.all(color: palette.outlineVariant),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                    child: Image.file(
                      File(imagePath),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Reads the stored `matchedText|Name;;…` blob and returns a de-duplicated,
  /// comma-separated list of flagged ingredient names, or null if there are
  /// none to show.
  String? _flaggedNames(String? flaggedJson) {
    if (flaggedJson == null || flaggedJson.isEmpty) return null;

    final names = <String>[];
    for (final entry in flaggedJson.split(';;')) {
      if (entry.isEmpty) continue;
      final name = entry.contains('|') ? entry.split('|').last : entry;
      final trimmed = name.trim();
      if (trimmed.isNotEmpty && !names.contains(trimmed)) names.add(trimmed);
    }
    return names.isEmpty ? null : names.join(', ');
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${_month(date.month)} ${date.day}';
  }

  static String _month(int m) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][m - 1];
}
