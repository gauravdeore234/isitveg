import 'package:flutter/material.dart';
import '../config/theme.dart';

/// Shared TopAppBar: 64px tall, centered "IsItVeg" wordmark in primary,
/// 1px outline-variant bottom rule (design system — all screens).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget> actions;
  final String title;

  const AppTopBar({
    super.key,
    this.leading,
    this.actions = const [],
    this.title = 'IsItVeg',
  });

  /// Back-button variant used by task-focused sub-pages.
  factory AppTopBar.back(BuildContext context, {String title = 'IsItVeg'}) {
    return AppTopBar(
      title: title,
      leading: const _BackButton(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: palette.outlineVariant)),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin - 8,
                ),
                child: Row(
                  children: [
                    // 48px slots: the icons read as 40px per the design, but
                    // Material reserves a 48px tap target around them.
                    SizedBox(width: 48, height: 48, child: leading),
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: AppText.headlineMd(palette.primary),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: actions.isEmpty
                          ? null
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: actions,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return AppBarIconButton(
      icon: Icons.arrow_back,
      onPressed: () => Navigator.of(context).maybePop(),
      tooltip: 'Back',
    );
  }
}

/// 40x40 circular icon button used in the top app bar.
class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      style: IconButton.styleFrom(
        shape: const CircleBorder(),
        foregroundColor: context.palette.onSurfaceVariant,
        highlightColor: context.palette.surfaceContainerHigh,
      ),
      icon: Icon(icon, size: 24),
    );
  }
}

/// Centers page content in a 600px canvas (design system: tablet/desktop rule).
class AppContentCanvas extends StatelessWidget {
  final Widget child;
  const AppContentCanvas({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: child,
      ),
    );
  }
}
