class LocationModel {
  final String id;
  final String nameEn;
  final String nameMk;
  final String type;
  final double latitude;
  final double longitude;
  final String? descriptionEn;
  final String? descriptionMk;
  final bool isActive;
  final List<String> searchKeywords;
  final List<String> lineIds;
  final List<String> imageAssetPaths;
  final int? discountPercent;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LocationModel({
    required this.id,
    required this.nameEn,
    required this.nameMk,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.descriptionEn,
    this.descriptionMk,
    required this.isActive,
    required this.searchKeywords,
    this.lineIds = const [],
    this.imageAssetPaths = const [],
    this.discountPercent,
    this.createdAt,
    this.updatedAt,
  });

  factory LocationModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    final fallbackName = map['name']?.toString() ?? '';

    return LocationModel(
      id: documentId,
      nameEn: (map['nameEn']?.toString().trim().isNotEmpty ?? false)
          ? map['nameEn'].toString()
          : fallbackName,
      nameMk: (map['nameMk']?.toString().trim().isNotEmpty ?? false)
          ? map['nameMk'].toString()
          : fallbackName,
      type: map['type'] ?? '',
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      descriptionEn: map['descriptionEn'],
      descriptionMk: map['descriptionMk'],
      isActive: map['isActive'] ?? true,
      searchKeywords: List<String>.from(map['searchKeywords'] ?? []),
      lineIds: List<String>.from(map['lineIds'] ?? []),
      imageAssetPaths: List<String>.from(map['imageAssetPaths'] ?? []),
      discountPercent: map['discountPercent'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameEn': nameEn,
      'nameMk': nameMk,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'descriptionEn': descriptionEn,
      'descriptionMk': descriptionMk,
      'isActive': isActive,
      'searchKeywords': searchKeywords,
      'lineIds': lineIds,
      'imageAssetPaths': imageAssetPaths,
      'discountPercent': discountPercent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String nameFor(String languageCode) {
    if (languageCode == 'mk') {
      return nameMk.trim().isNotEmpty ? nameMk : nameEn;
    }
    return nameEn.trim().isNotEmpty ? nameEn : nameMk;
  }

  String descriptionFor(String languageCode) {
    if (languageCode == 'mk') {
      return (descriptionMk?.trim().isNotEmpty ?? false)
          ? descriptionMk!
          : (descriptionEn ?? '');
    }

    return (descriptionEn?.trim().isNotEmpty ?? false)
        ? descriptionEn!
        : (descriptionMk ?? '');
  }

  List<String> get resolvedImages {
    if (imageAssetPaths.isEmpty) {
      return ['assets/images/default.png'];
    }

    return imageAssetPaths
        .map((name) => 'assets/images/locations/$name.jpg')
        .toList();
  }
}