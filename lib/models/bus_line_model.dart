class BusLineModel {
  final String id;
  final int number;
  final String name;
  final String colorHex;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const BusLineModel({
    required this.id,
    required this.number,
    required this.name,
    required this.colorHex,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory BusLineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BusLineModel(
      id: documentId,
      number: map['number'] ?? 0,
      name: map['name'] ?? '',
      colorHex: map['colorHex'] ?? '#000000',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'name': name,
      'colorHex': colorHex,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}