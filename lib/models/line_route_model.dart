class LineRouteModel {
  final String id;
  final String lineId;
  final String direction;
  final List<String> stopIdsOrdered;
  final List<Map<String, double>> polylinePoints;
  final String startLabel;
  final String endLabel;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LineRouteModel({
    required this.id,
    required this.lineId,
    required this.direction,
    required this.stopIdsOrdered,
    required this.polylinePoints,
    required this.startLabel,
    required this.endLabel,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LineRouteModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LineRouteModel(
      id: documentId,
      lineId: map['lineId'] ?? '',
      direction: map['direction'] ?? '',
      stopIdsOrdered: List<String>.from(map['stopIdsOrdered'] ?? []),
      polylinePoints: (map['polylinePoints'] as List<dynamic>? ?? [])
          .map<Map<String, double>>(
            (point) => {
          'latitude': (point['latitude'] ?? 0).toDouble(),
          'longitude': (point['longitude'] ?? 0).toDouble(),
        },
      )
          .toList(),
      startLabel: map['startLabel'] ?? '',
      endLabel: map['endLabel'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lineId': lineId,
      'direction': direction,
      'stopIdsOrdered': stopIdsOrdered,
      'polylinePoints': polylinePoints,
      'startLabel': startLabel,
      'endLabel': endLabel,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}