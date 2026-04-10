import 'package:flutter/material.dart';
import 'package:monkey_ride/widgets/common/app_surface_styles.dart';


class AppButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;

  final bool isIconOnly;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    this.isIconOnly = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: isIconOnly ? 12 : 18,
                vertical: isIconOnly ? 12 : 10,
              ),
          decoration: AppSurfaceStyles.card(
            context,
            backgroundColor: Theme.of(context).colorScheme.surface,
            radius: 14,
            isHighlighted: false,
          ),
          child: isIconOnly
              ? Icon(
            icon,
            size: 22,
            color: isDark ? Colors.white : Colors.black,
          )
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 8),
              ],
              if (label != null)
                Text(
                  label!,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}