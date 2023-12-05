import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class RedAlertLogger {
  static final Logger _logger = Logger();

  static void logInfo(String message) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    final logMessage = '[$formattedDate] $message';

    _logger.i(logMessage);
  }

  static void logError(String message, [dynamic error, StackTrace stackTrace]) {
    _logger.e(message, error, stackTrace);
  }
}