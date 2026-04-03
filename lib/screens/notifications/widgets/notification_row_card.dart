import 'package:flutter/material.dart';

import '../../../models/app_notification_model.dart';
import '../../../widgets/common/app_surface_styles.dart';

class NotificationRowCard extends StatelessWidget {
  final AppNotificationModel notification;
  final bool isRead;
  final String previewText;
  final String dateLabel;
  final String timeLabel;
  final VoidCallback onTap;

  const NotificationRowCard({
    super.key,
    required this.notification,
    required this.isRead,
    required this.previewText,
    required this.dateLabel,
    required this.timeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = isRead
        ? colorScheme.surface
        : colorScheme.primaryContainer.withOpacity(0.55);

    final borderColor = isRead
        ? colorScheme.outline.withOpacity(0.25)
        : colorScheme.primary.withOpacity(0.35);

    return Container(
      decoration: AppSurfaceStyles.card(
        context,
        backgroundColor: backgroundColor,
        borderColor: isRead
            ? null
            : Theme.of(context).colorScheme.primary.withOpacity(0.9),
        radius: 16,
        isHighlighted: !isRead,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                  child: isRead
                      ? null
                      : Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        previewText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeLabel,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}