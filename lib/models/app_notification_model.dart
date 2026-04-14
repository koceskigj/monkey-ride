class AppNotificationModel {
  final String id;
  final String titleEn;
  final String titleMk;
  final String messageEn;
  final String messageMk;
  final String type;
  final bool isActive;
  final DateTime? publishedAt;
  final DateTime? expiresAt;

  const AppNotificationModel({
    required this.id,
    required this.titleEn,
    required this.titleMk,
    required this.messageEn,
    required this.messageMk,
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
      titleEn: map['titleEn'] ?? '',
      titleMk: map['titleMk'] ?? '',
      messageEn: map['messageEn'] ?? '',
      messageMk: map['messageMk'] ?? '',
      type: map['type'] ?? 'info',
      isActive: map['isActive'] ?? true,
      publishedAt: map['publishedAt']?.toDate(),
      expiresAt: map['expiresAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titleEn': titleEn,
      'titleMk': titleMk,
      'messageEn': messageEn,
      'messageMk': messageMk,
      'type': type,
      'isActive': isActive,
      'publishedAt': publishedAt,
      'expiresAt': expiresAt,
    };
  }

  String titleFor(String languageCode) {
    if (languageCode == 'mk') {
      return titleMk.trim().isNotEmpty ? titleMk : titleEn;
    }
    return titleEn.trim().isNotEmpty ? titleEn : titleMk;
  }

  String messageFor(String languageCode) {
    if (languageCode == 'mk') {
      return messageMk.trim().isNotEmpty
          ? messageMk
          : messageEn;
    }
    return messageEn.trim().isNotEmpty
        ? messageEn
        : messageMk;
  }
}