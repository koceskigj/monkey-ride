import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../app/localization/locale_provider.dart';
import '../../app/theme/theme_provider.dart';
import '../../core/utils/app_error_messages.dart';
import '../../models/location_model.dart';
import '../../providers/location_provider.dart';
import '../../providers/map_provider.dart';
import '../../widgets/common/app_error_state.dart';
import 'widgets/map_filters_button.dart';
import 'widgets/map_filters_sheet.dart';
import 'widgets/map_legend_button.dart';
import 'widgets/map_recenter_button.dart';
import 'widgets/place_details_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  String? _darkMapStyle;
  String? _lightMapStyle;

  BitmapDescriptor? _busStopMarker;
  BitmapDescriptor? _ticketOfficeMarker;
  BitmapDescriptor? _attractionMarker;
  BitmapDescriptor? _cafeMarker;

  bool _didLoadAssets = false;
  bool? _lastAppliedIsDarkMode;
  int _mapRebuildKey = 0;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(41.3451, 21.5550),
    zoom: 13.8,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMapStyles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didLoadAssets) {
      _didLoadAssets = true;
      _loadMarkerIcons();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _mapRebuildKey++;
      });

      final isDarkMode = context.read<ThemeProvider>().isDarkMode;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _applyMapStyle(isDarkMode);
      });
    }
  }

  Future<void> _loadMapStyles() async {
    final darkStyle = await rootBundle.loadString(
      'assets/map_styles/dark_map_style.json',
    );

    final lightStyle = await rootBundle.loadString(
      'assets/map_styles/light_map_style.json',
    );

    if (!mounted) return;

    setState(() {
      _darkMapStyle = darkStyle;
      _lightMapStyle = lightStyle;
    });
  }

  Future<void> _loadMarkerIcons() async {
    final imageConfiguration = createLocalImageConfiguration(context);

    final busStop = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/monkey_stop.png',
      width: 28,
      height: 28,
    );

    final ticketOffice = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/ticket_office.png',
      width: 24,
      height: 24,
    );

    final attraction = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/attraction.png',
      width: 24,
      height: 24,
    );

    final cafe = await BitmapDescriptor.asset(
      imageConfiguration,
      'assets/icons/cafe.png',
      width: 24,
      height: 24,
    );

    if (!mounted) return;

    setState(() {
      _busStopMarker = busStop;
      _ticketOfficeMarker = ticketOffice;
      _attractionMarker = attraction;
      _cafeMarker = cafe;
    });
  }

  Future<void> _applyMapStyle(bool isDarkMode) async {
    if (_mapController == null) return;

    final styleToApply = isDarkMode ? _darkMapStyle : _lightMapStyle;
    if (styleToApply == null) return;

    await _mapController!.setMapStyle(styleToApply);
    _lastAppliedIsDarkMode = isDarkMode;
  }

  Future<void> _recenterToUser(LocationProvider locationProvider) async {
    await locationProvider.refreshLocationState();

    if (!locationProvider.isEnabled) {
      await locationProvider.openLocationAccessFlow();
      await locationProvider.refreshLocationState();

      if (!locationProvider.isEnabled) {
        return;
      }
    }

    if (locationProvider.currentPosition == null) {
      await locationProvider.getCurrentLocation();
    }

    final position = locationProvider.currentPosition;
    if (position == null || _mapController == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15.5,
        ),
      ),
    );
  }

  void _showLegendDialog(String languageCode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            languageCode == 'mk' ? 'Легенда на мапа' : 'Map Legend',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendImageRow(
                imagePath: 'assets/icons/monkey_stop.png',
                label: languageCode == 'mk' ? 'Постoјка' : 'Bus stop',
              ),
              const SizedBox(height: 12),
              _LegendImageRow(
                imagePath: 'assets/icons/ticket_office.png',
                label: languageCode == 'mk' ? 'Билетара' : 'Ticket office',
              ),
              const SizedBox(height: 12),
              _LegendImageRow(
                imagePath: 'assets/icons/attraction.png',
                label: languageCode == 'mk' ? 'Атракција' : 'Attraction',
              ),
              const SizedBox(height: 12),
              _LegendImageRow(
                imagePath: 'assets/icons/cafe.png',
                label: languageCode == 'mk' ? 'Кафуле' : 'Cafe',
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFiltersSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      builder: (_) => const MapFiltersSheet(),
    );
  }

  void _showPlaceDetails(LocationModel location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => PlaceDetailsSheet(location: location),
    );
  }

  Color _hexToColor(String hex) {
    final cleanedHex = hex.replaceAll('#', '');
    return Color(int.parse('FF$cleanedHex', radix: 16));
  }

  Set<Polyline> _buildPolylines(MapProvider mapProvider) {
    final sortedRoutes = [...mapProvider.selectedRoutes]
      ..sort((a, b) {
        final lineA = mapProvider.busLines.firstWhere(
              (line) => line.id == a.lineId,
        );
        final lineB = mapProvider.busLines.firstWhere(
              (line) => line.id == b.lineId,
        );

        return lineB.number.compareTo(lineA.number);
      });

    return sortedRoutes.map((route) {
      final line = mapProvider.busLines.firstWhere(
            (line) => line.id == route.lineId,
      );

      return Polyline(
        polylineId: PolylineId(route.id),
        width: 5,
        zIndex: 5 - line.number,
        color: _hexToColor(line.colorHex),
        points: route.polylinePoints
            .map(
              (point) => LatLng(
            ((point['latitude'] as num?) ?? 0).toDouble(),
            ((point['longitude'] as num?) ?? 0).toDouble(),
          ),
        )
            .toList(),
      );
    }).toSet();
  }

  BitmapDescriptor _markerIconForType(String type) {
    switch (type) {
      case 'bus_stop':
        return _busStopMarker ?? BitmapDescriptor.defaultMarker;
      case 'ticket_office':
        return _ticketOfficeMarker ?? BitmapDescriptor.defaultMarker;
      case 'landmark':
        return _attractionMarker ?? BitmapDescriptor.defaultMarker;
      case 'cafe':
        return _cafeMarker ?? BitmapDescriptor.defaultMarker;
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Set<Marker> _buildMarkers(
      MapProvider mapProvider,
      String languageCode,
      ) {
    final visibleBusStops = mapProvider.selectedRouteStops;
    final otherLocations = mapProvider.locations
        .where((location) => location.type != 'bus_stop')
        .toList();

    final allVisibleLocations = [
      ...visibleBusStops,
      ...otherLocations,
    ];

    return allVisibleLocations.map((location) {
      final lineNumbers = mapProvider.getLineNumbersForStop(location.id);

      return Marker(
        markerId: MarkerId(location.id),
        position: LatLng(location.latitude, location.longitude),
        icon: _markerIconForType(location.type),
        infoWindow: InfoWindow(
          title: location.nameFor(languageCode),
          snippet: location.type == 'bus_stop'
              ? (languageCode == 'mk'
              ? 'Линии: ${lineNumbers.join(', ')}'
              : 'Lines: ${lineNumbers.join(', ')}')
              : mapProvider.getShortDescription(
            location.descriptionFor(languageCode),
          ),
        ),
        onTap: () {
          if (location.type == 'landmark' || location.type == 'cafe') {
            _showPlaceDetails(location);
          }
        },
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final languageCode = localeProvider.locale.languageCode;

    final locationProvider = context.watch<LocationProvider>();
    final mapProvider = context.watch<MapProvider>();
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    if (_mapController != null && _lastAppliedIsDarkMode != isDarkMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyMapStyle(isDarkMode);
      });
    }

    if (mapProvider.isLoading && !mapProvider.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (mapProvider.errorMessage != null && !mapProvider.hasData) {
      return AppErrorState(
        message: mapProvider.errorMessage!,
        imageAssetPath: AppErrorMessages.imageForType(mapProvider.errorType),
        onRetry: mapProvider.loadMapData,
      );
    }

    return Stack(
      children: [
        GoogleMap(
          key: ValueKey(_mapRebuildKey),
          initialCameraPosition: _initialCameraPosition,
          myLocationEnabled: locationProvider.isGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          compassEnabled: true,
          mapToolbarEnabled: false,
          polylines: _buildPolylines(mapProvider),
          markers: _buildMarkers(mapProvider, languageCode),
          onMapCreated: (controller) async {
            _mapController = controller;
            await _applyMapStyle(isDarkMode);
          },
        ),
        Positioned(
          right: 16,
          top: MediaQuery.of(context).size.height * 0.34,
          child: Column(
            children: [
              MapRecenterButton(
                onPressed: () => _recenterToUser(locationProvider),
              ),
              const SizedBox(height: 12),
              MapLegendButton(
                onPressed: () => _showLegendDialog(languageCode),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 36,
          child: MapFiltersButton(
            onPressed: _showFiltersSheet,
          ),
        ),
      ],
    );
  }
}

class _LegendImageRow extends StatelessWidget {
  final String imagePath;
  final String label;

  const _LegendImageRow({
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 22,
          height: 22,
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}