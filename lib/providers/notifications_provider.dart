import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/notifications_firestore_service.dart';
import '../core/utils/app_error_messages.dart';
import '../models/app_notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  static const String _readIdsKey = 'read_notification_ids';

  final NotificationsFirestoreService _service;

  NotificationsProvider({NotificationsFirestoreService? service})
      : _service = service ?? NotificationsFirestoreService();

  List<AppNotificationModel> _notifications = [];
  Set<String> _readIds = {};
  bool _isLoading = false;
  String? _errorMessage;
  AppErrorType _errorType = AppErrorType.server;

  List<AppNotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppErrorType get errorType => _errorType;

  bool get hasData => _notifications.isNotEmpty;

  bool isRead(String id) => _readIds.contains(id);

  bool get hasUnread {
    return _notifications.any(
          (notification) => !_readIds.contains(notification.id),
    );
  }

  Future<void> initialize() async {
    await _loadReadIds();
    await loadNotifications();
  }

  Future<void> _loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_readIdsKey) ?? [];
    _readIds = stored.toSet();
    notifyListeners();
  }

  Future<void> _saveReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readIdsKey, _readIds.toList());
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    _errorType = AppErrorType.server;
    notifyListeners();

    try {
      final result = await _service.getNotifications(limit: 20);
      _notifications = result;
    } catch (e) {
      final errorInfo = AppErrorMessages.fromError(
        e,
        context: 'notifications',
      );
      _errorMessage = errorInfo.message;
      _errorType = errorInfo.type;
      _notifications = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    if (_readIds.contains(id)) return;

    _readIds.add(id);
    await _saveReadIds();
    notifyListeners();
  }

  String getPreviewText(String text, {int maxLength = 70}) {
    final trimmed = text.trim();
    if (trimmed.length <= maxLength) return trimmed;
    return '${trimmed.substring(0, maxLength)}...';
  }

  String formatNotificationDate(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day.$month.$year';
  }

  String formatNotificationTime(DateTime? date) {
    if (date == null) return '';

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }
}