import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/ingredient.dart';

class FlaggedIngredientCard extends StatelessWidget {
  final FlaggedIngredient flagged;

  const FlaggedIngredientCard({super.key, required this.flagged});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final ingredient = flagged.ingredient;
    final isDefinite = ingredient.severity == IngredientSeverity.definite;

    final categoryLabel = switch (ingredient.category) {
      IngredientCategory.meat => 'Animal-derived',
      IngredientCategory.poultry => 'Poultry-derived',
      IngredientCategory.fish => 'Fish/Seafood-derived',
      IngredientCategory.egg => 'Egg-derived',
      IngredientCategory.insect => 'Insect-derived',
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: palette.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: Row(
        children: [
          if (isDefinite) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: palette.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: isDefinite
                      ? AppText.bodyLg(palette.onSurface)
                          .copyWith(fontWeight: FontWeight.w700)
                      : AppText.titleLg(palette.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  isDefinite
                      ? 'Category: $categoryLabel'
                      : 'Potential animal origin',
                  style: AppText.bodySm(palette.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          isDefinite ? const _NonVegBadge() : const _PossiblyBadge(),
        ],
      ),
    );
  }
}

class _NonVegBadge extends StatelessWidget {
  const _NonVegBadge();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: palette.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child:
          Text('Non-Veg', style: AppText.labelCaps(palette.onErrorContainer)),
    );
  }
}

class _PossiblyBadge extends StatelessWidget {
  const _PossiblyBadge();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: palette.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: palette.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: palette.uncertain,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          Text('Possibly', style: AppText.labelCaps(palette.onSurface)),
        ],
      ),
    );
  }
}
