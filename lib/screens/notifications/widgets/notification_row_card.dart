import 'package:flutter/material.dart';

import '../../../models/app_notification_model.dart';
import '../../../widgets/common/app_surface_styles.dart';

class NotificationRowCard extends StatelessWidget {
  final AppNotificationModel notification;
  final String titleText;
  final bool isRead;
  final String previewText;
  final String dateLabel;
  final String timeLabel;
  final VoidCallback onTap;

  const NotificationRowCard({
    super.key,
    required this.notification,
    required this.titleText,
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

    return Container(
      decoration: AppSurfaceStyles.card(
        context,
        backgroundColor: backgroundColor,
        radius: 16,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
          child: Row(
            children: [
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleText,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(previewText),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(dateLabel),
                  Text(timeLabel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}