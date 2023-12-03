import 'package:logger/logger.dart';

class RedAlertLogger {
  static final Logger _logger = Logger();

  static void logInfo(String message) {
    _logger.i(message);
  }

  static void logError(String message, [dynamic error, StackTrace stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}