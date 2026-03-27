class InfoSlideModel {
  final String id;
  final String title;
  final String description;
  final String imageAssetPath;
  final int orderIndex;
  final bool isActive;

  const InfoSlideModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageAssetPath,
    required this.orderIndex,
    required this.isActive,
  });

  factory InfoSlideModel.fromMap(Map<String, dynamic> map, String documentId) {
    return InfoSlideModel(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageAssetPath: map['imageAssetPath'] ?? '',
      orderIndex: map['orderIndex'] ?? 0,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageAssetPath': imageAssetPath,
      'orderIndex': orderIndex,
      'isActive': isActive,
    };
  }
}