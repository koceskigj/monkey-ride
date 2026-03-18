class AppNotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isActive;
  final DateTime? publishedAt;
  final DateTime? expiresAt;

  const AppNotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isActive,
    this.publishedAt,
    this.expiresAt,
  });

  factory AppNotificationModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return AppNotificationModel(
      id: documentId,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'info',
      isActive: map['isActive'] ?? true,
      publishedAt: map['publishedAt']?.toDate(),
      expiresAt: map['expiresAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'isActive': isActive,
      'publishedAt': publishedAt,
      'expiresAt': expiresAt,
    };
  }
}