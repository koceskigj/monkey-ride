import 'package:flutter/material.dart';

class AppSurfaceStyles {
  static BoxDecoration card(
      BuildContext context, {
        Color? backgroundColor,
        Color? borderColor,
        double radius = 16,
        bool isHighlighted = false,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedBorderColor = borderColor ??
        (isDark
            ? colorScheme.primary.withOpacity(isHighlighted ? 0.95 : 0.72)
            : colorScheme.primary.withOpacity(isHighlighted ? 0.60 : 0.42));

    return BoxDecoration(
      color: backgroundColor ?? colorScheme.surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: resolvedBorderColor,
        width: isHighlighted ? 1.8 : 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.22 : 0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}