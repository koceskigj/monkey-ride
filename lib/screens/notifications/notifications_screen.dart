import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/localization/locale_provider.dart';
import '../../core/utils/app_error_messages.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/common/app_error_state.dart';
import 'widgets/notification_dialog.dart';
import 'widgets/notification_row_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final languageCode = localeProvider.locale.languageCode;

    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null && !provider.hasData) {
      return AppErrorState(
        message: provider.errorMessage!,
        imageAssetPath:
        AppErrorMessages.imageForType(provider.errorType),
        onRetry: provider.loadNotifications,
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.notifications.length,
        itemBuilder: (context, index) {
          final n = provider.notifications[index];
          final localizedTitle = n.titleFor(languageCode);
          final localizedMessage = n.messageFor(languageCode);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NotificationRowCard(
              notification: n,
              titleText: localizedTitle,
              isRead: provider.isRead(n.id),
              previewText:
              provider.getPreviewText(localizedMessage),
              dateLabel: provider.formatNotificationDate(
                n.publishedAt,
              ),
              timeLabel: provider.formatNotificationTime(
                n.publishedAt,
              ),
              onTap: () async {
                await provider.markAsRead(n.id);

                if (!context.mounted) return;

                showDialog(
                  context: context,
                  builder: (_) => NotificationDialog(
                    notification: n,
                    dateLabel: provider.formatNotificationDate(
                      n.publishedAt,
                    ),
                    timeLabel: provider.formatNotificationTime(
                      n.publishedAt,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}