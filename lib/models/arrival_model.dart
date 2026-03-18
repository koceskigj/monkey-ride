class ArrivalModel {
  final String id;
  final String stopId;
  final String lineId;
  final String routeId;
  final String destination;
  final List<String> arrivalTimes;
  final DateTime? updatedAt;

  const ArrivalModel({
    required this.id,
    required this.stopId,
    required this.lineId,
    required this.routeId,
    required this.destination,
    required this.arrivalTimes,
    this.updatedAt,
  });

  factory ArrivalModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ArrivalModel(
      id: documentId,
      stopId: map['stopId'] ?? '',
      lineId: map['lineId'] ?? '',
      routeId: map['routeId'] ?? '',
      destination: map['destination'] ?? '',
      arrivalTimes: List<String>.from(map['arrivalTimes'] ?? []),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'stopId': stopId,
      'lineId': lineId,
      'routeId': routeId,
      'destination': destination,
      'arrivalTimes': arrivalTimes,
      'updatedAt': updatedAt,
    };
  }
}