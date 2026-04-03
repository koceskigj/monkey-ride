import 'package:cloud_firestore/cloud_firestore.dart';

enum AppErrorType {
  network,
  permission,
  configuration,
  notFound,
  unknown,
}

class AppErrorInfo {
  final String message;
  final AppErrorType type;

  const AppErrorInfo({
    required this.message,
    required this.type,
  });
}

class AppErrorMessages {
  static AppErrorInfo fromError(Object error, {String context = 'data'}) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return AppErrorInfo(
            message:
            "I can't reach the server right now. Check your internet and try again.",
            type: AppErrorType.network,
          );

        case 'permission-denied':
          return AppErrorInfo(
            message:
            "I don't have permission to load this $context. Something's not set up right.",
            type: AppErrorType.permission,
          );

        case 'failed-precondition':
          return AppErrorInfo(
            message:
            "Something isn't configured properly yet. I'm still fixing things behind the scenes.",
            type: AppErrorType.configuration,
          );

        case 'not-found':
          return AppErrorInfo(
            message: "I couldn't find the $context you're looking for.",
            type: AppErrorType.notFound,
          );

        default:
          return AppErrorInfo(
            message:
            "Something went wrong while loading $context. I'm working on fixing it.",
            type: AppErrorType.unknown,
          );
      }
    }

    final text = error.toString().toLowerCase();

    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('network')) {
      return const AppErrorInfo(
        message:
        "I can't connect to the internet right now. Check your connection and try again.",
        type: AppErrorType.network,
      );
    }

    return AppErrorInfo(
      message:
      "Something unexpected happened while loading $context. I'm trying to fix it.",
      type: AppErrorType.unknown,
    );
  }

  static String imageForType(AppErrorType type) {
    switch (type) {
      case AppErrorType.network:
        return 'assets/images/error/mende_no_internet.png';
      case AppErrorType.permission:
      case AppErrorType.configuration:
      case AppErrorType.notFound:
      case AppErrorType.unknown:
        return 'assets/images/error/mende_server_error.png';
    }
  }
}