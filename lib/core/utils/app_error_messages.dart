enum AppErrorType {
  server,
  noInternet,
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
    final text = error.toString().toLowerCase();

    if (text.contains('unable to resolve host') ||
        text.contains('unknownhostexception') ||
        text.contains('failed host lookup') ||
        text.contains('network is unreachable') ||
        text.contains('firestore.googleapis.com') ||
        text.contains('socketexception') ||
        text.contains('unavailable')) {
      return const AppErrorInfo(
        message: 'errorNoInternet',
        type: AppErrorType.noInternet,
      );
    }

    return const AppErrorInfo(
      message: 'errorServer',
      type: AppErrorType.server,
    );
  }

  static String imageForType(AppErrorType type) {
    switch (type) {
      case AppErrorType.noInternet:
        return 'assets/images/error/mende_no_internet.png';
      case AppErrorType.server:
        return 'assets/images/error/mende_server_error.png';
    }
  }
}