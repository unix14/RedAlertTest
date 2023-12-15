import 'dart:async';

import 'package:red_alert_test_android/custom/red_alert_logger.dart';
import 'package:red_alert_test_android/di/di.dart';
import 'package:red_alert_test_android/logic/red_alert_respository.dart';

/// Main entry point of the application.
Future<void> main() async {
  final RedAlertRepository _redAlertRepo = DI.getSingleton<RedAlertRepository>();

  RedAlertLogger.logInfo('Running Red Alert');

  while (true) {
    final cityData = <Map<String, dynamic>>[];
    var migunTime = 0;

    await Future.delayed(Duration(seconds: 2));

    final redAlerts = await _redAlertRepo.getRedAlerts();

    if (redAlerts != null) {
      for (final alertCity in redAlerts['data']) {
        // final alertId = redAlerts["id"];
        for (final location in _redAlertRepo.selectedAreas) {
          if (location.label == alertCity) {
            migunTime = alertCity['migun_time'];
            cityData.add(alertCity);
          }
        }
        redAlerts['cities_labels'] = cityData;
        redAlerts['time_to_run'] = migunTime;

        // todo Do whatever you need to do with the data
        // RedAlertLogger.logInfo("cityData.length is" + cityData.length.toString());
        // RedAlertLogger.logInfo("migunTime is" + migunTime.toString());
      }
    } else {
      // RedAlertLogger.logInfo("[-] No alerts for now, keep checking ...");
    }
  }
}
