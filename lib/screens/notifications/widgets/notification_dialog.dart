import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/localization/locale_provider.dart';
import '../../../models/app_notification_model.dart';

class NotificationDialog extends StatelessWidget {
  final AppNotificationModel notification;
  final String dateLabel;
  final String timeLabel;

  const NotificationDialog({
    super.key,
    required this.notification,
    required this.dateLabel,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final languageCode = localeProvider.locale.languageCode;
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.titleFor(languageCode),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    notification.messageFor(languageCode),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: Text('$dateLabel, $timeLabel'),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    languageCode == 'mk' ? 'Затвори' : 'Close',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}