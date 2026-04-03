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
  AppErrorType _errorType = AppErrorType.unknown;

  String? _currentStopId;
  String? _currentDirection;

  Timer? _alignmentTimer;
  Timer? _refreshTimer;

  List<UpcomingArrivalModel> get upcomingArrivals => _upcomingArrivals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AppErrorType get errorType => _errorType;

  Future<void> loadArrivals({
    required String stopId,
    required String direction,
  }) async {
    _currentStopId = stopId;
    _currentDirection = direction;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print('🚌 [ARRIVALS] Loading arrivals...');
    print('🚌 [ARRIVALS] stopId: $stopId');
    print('🚌 [ARRIVALS] direction: $direction');

    try {
      final now = DateTime.now();

      final relevantTimetables = await _service.getArrivalsForStop(
        stopId: stopId,
        direction: direction,
      );

      print('🚌 [ARRIVALS] Firestore returned ${relevantTimetables.length} timetable docs');

      final List<UpcomingArrivalModel> arrivals = [];

      for (final timetable in relevantTimetables) {
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

      _upcomingArrivals = arrivals.take(5).toList();

      print('✅ [ARRIVALS] Computed ${_upcomingArrivals.length} upcoming arrivals');
    } catch (e, stackTrace) {
      print('❌ [ARRIVALS] Error loading arrivals: $e');
      print(stackTrace);

      final errorInfo = AppErrorMessages.fromError(
        e,
        context: 'arrival times',
      );
      _errorMessage = errorInfo.message;
      _errorType = errorInfo.type;
      _upcomingArrivals = [];
    } finally {
      _isLoading = false;
      notifyListeners();
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
      if (_currentStopId != null && _currentDirection != null) {
        await loadArrivals(
          stopId: _currentStopId!,
          direction: _currentDirection!,
        );
      }

      _refreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
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
    stopAutoRefresh();
    super.dispose();
  }
}