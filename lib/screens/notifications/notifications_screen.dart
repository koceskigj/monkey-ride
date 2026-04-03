import 'package:flutter/material.dart';
import 'package:monkey_ride/core/utils/app_error_messages.dart';
import 'package:provider/provider.dart';

import '../../providers/notifications_provider.dart';
import '../../widgets/common/app_error_state.dart';
import 'widgets/notification_dialog.dart';
import 'widgets/notification_row_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (provider.errorMessage != null && provider.notifications.isEmpty) {
      return AppErrorState(
        message: provider.errorMessage!,
        imageAssetPath: AppErrorMessages.imageForType(provider.errorType),
        onRetry: provider.loadNotifications,
      );
    }

    if (provider.notifications.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.loadNotifications,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 180),
            Center(
              child: Text('No notifications yet.'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadNotifications,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: provider.notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notification = provider.notifications[index];
          final isRead = provider.isRead(notification.id);
          final preview = provider.getPreviewText(notification.message);
          final dateLabel = provider.formatNotificationDate(notification.publishedAt);

          return NotificationRowCard(
            notification: notification,
            isRead: isRead,
            previewText: preview,
            dateLabel: dateLabel,
            onTap: () async {
              await provider.markAsRead(notification.id);

              if (!context.mounted) return;

              showDialog(
                context: context,
                builder: (_) => NotificationDialog(
                  notification: notification,
                  dateLabel: dateLabel,
                ),
              );
            },
          );
        },
      ),
    );
  }
}