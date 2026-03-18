class LocationModel {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String? description;
  final bool isActive;
  final List<String> searchKeywords;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.description,
    required this.isActive,
    required this.searchKeywords,
    this.createdAt,
    this.updatedAt,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LocationModel(
      id: documentId,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      description: map['description'],
      isActive: map['isActive'] ?? true,
      searchKeywords: List<String>.from(map['searchKeywords'] ?? []),
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'isActive': isActive,
      'searchKeywords': searchKeywords,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}