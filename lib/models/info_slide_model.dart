class InfoSlideModel {
  final String id;
  final String titleEn;
  final String titleMk;
  final String descriptionEn;
  final String descriptionMk;
  final String imageAssetPath;
  final int orderIndex;
  final bool isActive;

  const InfoSlideModel({
    required this.id,
    required this.titleEn,
    required this.titleMk,
    required this.descriptionEn,
    required this.descriptionMk,
    required this.imageAssetPath,
    required this.orderIndex,
    required this.isActive,
  });

  factory InfoSlideModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return InfoSlideModel(
      id: documentId,
      titleEn: map['titleEn'] ?? '',
      titleMk: map['titleMk'] ?? '',
      descriptionEn: map['descriptionEn'] ?? '',
      descriptionMk: map['descriptionMk'] ?? '',
      imageAssetPath: map['imageAssetPath'] ?? '',
      orderIndex: map['orderIndex'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titleEn': titleEn,
      'titleMk': titleMk,
      'descriptionEn': descriptionEn,
      'descriptionMk': descriptionMk,
      'imageAssetPath': imageAssetPath,
      'orderIndex': orderIndex,
      'isActive': isActive,
    };
  }

  String titleFor(String languageCode) {
    if (languageCode == 'mk') {
      return titleMk.trim().isNotEmpty ? titleMk : titleEn;
    }
    return titleEn.trim().isNotEmpty ? titleEn : titleMk;
  }

  String descriptionFor(String languageCode) {
    if (languageCode == 'mk') {
      return descriptionMk.trim().isNotEmpty
          ? descriptionMk
          : descriptionEn;
    }
    return descriptionEn.trim().isNotEmpty
        ? descriptionEn
        : descriptionMk;
  }
}