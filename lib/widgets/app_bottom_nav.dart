import 'package:flutter/material.dart';
import '../config/theme.dart';

class AppNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// BottomNavBar from the design system: flat bar on surface-container-lowest
/// with a 1px top rule; the active destination is a filled pill in
/// primary-container / on-primary-container.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppNavItem> items;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  static const List<AppNavItem> defaultItems = [
    AppNavItem(
      icon: Icons.document_scanner_outlined,
      activeIcon: Icons.document_scanner,
      label: 'Scan',
    ),
    AppNavItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
    ),
    AppNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceContainerLowest,
        border: Border(top: BorderSide(color: palette.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        // heightFactor: 1 makes this hug the row. A plain Center would expand
        // to the loose height Scaffold offers, i.e. the whole screen.
        child: Align(
          alignment: Alignment.center,
          heightFactor: 1,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.base,
              ),
              child: Row(
                children: [
                  // Equal flexible slots: the pill hugs its label, but a narrow
                  // screen or a large text scale can never overflow the bar.
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      // heightFactor: 1 — a bare Center expands to the loose
                      // height it is offered, which stretches the whole bar.
                      child: Center(
                        heightFactor: 1,
                        child: _NavDestination(
                          item: items[i],
                          selected: i == currentIndex,
                          onTap: () => onTap(i),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination extends StatelessWidget {
  final AppNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavDestination({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground =
        selected ? palette.onPrimaryContainer : palette.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? palette.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                size: 24,
                color: foreground,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.labelCaps(foreground),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
