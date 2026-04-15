import 'package:flutter/material.dart';
import 'package:monkey_ride/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/localization/locale_provider.dart';
import '../../core/utils/app_error_messages.dart';
import '../../models/bus_line_model.dart';
import '../../models/location_model.dart';
import '../../providers/arrivals_provider.dart';
import '../../providers/map_provider.dart';
import '../../widgets/common/app_error_state.dart';
import 'widgets/arrival_row_card.dart';
import 'widgets/no_buses_left_state.dart';

class StopArrivalsScreen extends StatelessWidget {
  final LocationModel stop;
  final String direction;

  const StopArrivalsScreen({
    super.key,
    required this.stop,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArrivalsProvider()
        ..loadArrivals(
          stopId: stop.id,
          direction: direction,
        )
        ..startAutoRefresh(),
      child: _StopArrivalsView(
        stop: stop,
        direction: direction,
      ),
    );
  }
}

class _StopArrivalsView extends StatelessWidget {
  final LocationModel stop;
  final String direction;

  const _StopArrivalsView({
    required this.stop,
    required this.direction,
  });

  String _resolveArrivalText(String raw, AppLocalizations l10n) {
    if (raw == 'now') {
      return l10n.now;
    }

    if (raw.startsWith('minutes:')) {
      final minutes = int.tryParse(raw.split(':')[1]) ?? 0;
      return l10n.minutesShort(minutes);
    }

    if (raw.startsWith('hours:')) {
      final hours = int.tryParse(raw.split(':')[1]) ?? 0;
      return l10n.hoursShort(hours);
    }

    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final languageCode = localeProvider.locale.languageCode;
    final l10n = AppLocalizations.of(context)!;

    final arrivalsProvider = context.watch<ArrivalsProvider>();
    final mapProvider = context.watch<MapProvider>();

    BusLineModel? lineById(String id) {
      try {
        return mapProvider.busLines.firstWhere((line) => line.id == id);
      } catch (_) {
        return null;
      }
    }

    return PopScope(
      onPopInvokedWithResult: (_, __) {
        context.read<ArrivalsProvider>().stopAutoRefresh();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Text(stop.nameFor(languageCode)),
        ),
        body: Builder(
          builder: (context) {
            if (arrivalsProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (arrivalsProvider.errorMessage != null) {
              return AppErrorState(
                message: arrivalsProvider.errorMessage!,
                imageAssetPath: AppErrorMessages.imageForType(
                  arrivalsProvider.errorType,
                ),
                onRetry: () {
                  arrivalsProvider.loadArrivals(
                    stopId: stop.id,
                    direction: direction,
                  );
                },
              );
            }

            if (arrivalsProvider.upcomingArrivals.isEmpty) {
              return const NoBusesLeftState();
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              itemCount: arrivalsProvider.upcomingArrivals.length,
              itemBuilder: (context, index) {
                final arrival = arrivalsProvider.upcomingArrivals[index];
                final line = lineById(arrival.lineId);

                if (line == null) {
                  return const SizedBox.shrink();
                }

                final rawArrivalText = arrivalsProvider.formatArrivalText(
                  arrival.minutesUntilArrival,
                );

                return ArrivalRowCard(
                  line: line,
                  arrivalText: _resolveArrivalText(rawArrivalText, l10n),
                  isSoon: arrivalsProvider.isArrivingSoon(
                    arrival.minutesUntilArrival,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}