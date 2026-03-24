import 'package:flutter/material.dart';

import '../../../models/app_notification_model.dart';

class NotificationDialog extends StatelessWidget {
  final AppNotificationModel notification;
  final String dateLabel;

  const NotificationDialog({
    super.key,
    required this.notification,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: screenHeight * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 👈 important
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              /// 👇 THIS is the fix
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    notification.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}