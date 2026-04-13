import 'dart:async';

import 'package:flutter/material.dart';

import '../core/services/arrivals_firestore_service.dart';
import '../core/utils/app_error_messages.dart';
import '../models/upcoming_arrival_model.dart';

class ArrivalsProvider extends ChangeNotifier {
  final ArrivalsFirestoreService _service;

  ArrivalsProvider({ArrivalsFirestoreService? service})
      : _service = service ?? ArrivalsFirestoreService();

  List<UpcomingArrivalModel> _upcomingArrivals = [];
  bool _isLoading = false;
  String? _errorMessage;
  AppErrorType _errorType = AppErrorType.server;

  String? _currentStopId;
  String? _currentDirection;

  Timer? _alignmentTimer;
  Timer? _refreshTimer;
  bool _isDisposed = false;

  List<UpcomingArrivalModel> get upcomingArrivals => _upcomingArrivals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppErrorType get errorType => _errorType;

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  bool _isLineRunningToday(String lineId, DateTime now) {
    final isSunday = now.weekday == DateTime.sunday;

    if (lineId == 'line_4') {
      return isSunday;
    }

    return !isSunday;
  }

  Future<void> loadArrivals({
    required String stopId,
    required String direction,
  }) async {
    if (_isDisposed) return;

    _currentStopId = stopId;
    _currentDirection = direction;

    _isLoading = true;
    _errorMessage = null;
    _errorType = AppErrorType.server;
    _safeNotify();

    try {
      final now = DateTime.now();

      final relevantTimetables = await _service.getArrivalsForStop(
        stopId: stopId,
        direction: direction,
      );

      if (_isDisposed) return;

      if (relevantTimetables.isEmpty) {
        throw Exception(
          'No arrival timetable data was found for stopId=$stopId and direction=$direction.',
        );
      }

      final List<UpcomingArrivalModel> arrivals = [];

      for (final timetable in relevantTimetables) {
        if (!_isLineRunningToday(timetable.lineId, now)) {
          continue;
        }

        for (final departureTime in timetable.departureTimes) {
          final parts = departureTime.split(':');
          if (parts.length != 2) continue;

          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);

          if (hour == null || minute == null) continue;

          final todayDeparture = DateTime(
            now.year,
            now.month,
            now.day,
            hour,
            minute,
          );

          final minutesUntil = todayDeparture.difference(now).inMinutes;

          if (minutesUntil >= 0) {
            arrivals.add(
              UpcomingArrivalModel(
                routeId: timetable.routeId,
                stopId: timetable.stopId,
                lineId: timetable.lineId,
                minutesUntilArrival: minutesUntil,
              ),
            );
          }
        }
      }

      arrivals.sort(
            (a, b) => a.minutesUntilArrival.compareTo(b.minutesUntilArrival),
      );

      if (_isDisposed) return;

      _upcomingArrivals = arrivals.take(5).toList();
    } catch (e) {
      if (_isDisposed) return;

      final errorInfo = AppErrorMessages.fromError(
        e,
        context: 'arrival times',
      );
      _errorMessage = errorInfo.message;
      _errorType = errorInfo.type;
      _upcomingArrivals = [];
    } finally {
      if (_isDisposed) return;

      _isLoading = false;
      _safeNotify();
    }
  }

  void startAutoRefresh() {
    stopAutoRefresh();

    final now = DateTime.now();
    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );
    final delay = nextMinute.difference(now);

    _alignmentTimer = Timer(delay, () async {
      if (_isDisposed) return;

      if (_currentStopId != null && _currentDirection != null) {
        await loadArrivals(
          stopId: _currentStopId!,
          direction: _currentDirection!,
        );
      }

      if (_isDisposed) return;

      _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (_isDisposed) return;

        if (_currentStopId != null && _currentDirection != null) {
          loadArrivals(
            stopId: _currentStopId!,
            direction: _currentDirection!,
          );
        }
      });
    });
  }

  void stopAutoRefresh() {
    _alignmentTimer?.cancel();
    _alignmentTimer = null;

    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  String formatArrivalText(int minutes) {
    if (minutes <= 1) return 'Now';

    if (minutes >= 180) {
      final hours = minutes ~/ 60;
      return '${hours}h. +';
    }

    return '$minutes min.';
  }

  bool isArrivingSoon(int minutes) {
    return minutes <= 1 || minutes < 10;
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopAutoRefresh();
    super.dispose();
  }
}