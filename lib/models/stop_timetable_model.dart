class StopTimetableModel {
  final String id;
  final String routeId;
  final String stopId;
  final String direction;
  final String lineId;
  final List<String> departureTimes;
  final bool isActive;

  const StopTimetableModel({
    required this.id,
    required this.routeId,
    required this.stopId,
    required this.direction,
    required this.lineId,
    required this.departureTimes,
    required this.isActive,
  });

  factory StopTimetableModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return StopTimetableModel(
      id: documentId,
      routeId: map['routeId'] ?? '',
      stopId: map['stopId'] ?? '',
      direction: map['direction'] ?? '',
      lineId: map['lineId'] ?? '',
      departureTimes: List<String>.from(map['departureTimes'] ?? []),
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'stopId': stopId,
      'direction': direction,
      'lineId': lineId,
      'departureTimes': departureTimes,
      'isActive': isActive,
    };
  }
}