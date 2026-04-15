import 'package:flutter/material.dart';
import 'package:monkey_ride/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_error_messages.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/common/app_error_state.dart';
import 'widgets/notification_dialog.dart';
import 'widgets/notification_row_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  String _resolveDateLabel(String raw, AppLocalizations l10n) {
    switch (raw) {
      case 'today':
        return l10n.today;
      case 'yesterday':
        return l10n.yesterday;
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final l10n = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    if (provider.isLoading && provider.notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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

          final rawDate =
          provider.formatNotificationDate(n.publishedAt);

          final resolvedDate =
          _resolveDateLabel(rawDate, l10n);

          final time =
          provider.formatNotificationTime(n.publishedAt);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NotificationRowCard(
              notification: n,
              titleText: localizedTitle,
              isRead: provider.isRead(n.id),
              previewText:
              provider.getPreviewText(localizedMessage),
              dateLabel: resolvedDate,
              timeLabel: time,
              onTap: () async {
                await provider.markAsRead(n.id);

                if (!context.mounted) return;

                showDialog(
                  context: context,
                  builder: (_) => NotificationDialog(
                    notification: n,
                    dateLabel: resolvedDate,
                    timeLabel: time,
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