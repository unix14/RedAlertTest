import 'dart:async';
import 'package:red_alert_test/common/red_alert_logger.dart';
import 'package:red_alert_test/logic/red_alert.dart';

/// Main entry point of the application.
Future<void> main() async {
  final alert = RedAlert();

  RedAlertLogger.logInfo('Running Red Alert');

  while (true) {
    final cityData = <Map<String, dynamic>>[];
    var migunTime = 0;

    await Future.delayed(Duration(seconds: 2));

    final redAlerts = await alert.getRedAlerts();

    if (redAlerts != null) {
      for (final alertCity in redAlerts['data']) {
        // final alertId = redAlerts["id"];
        for (final location in alert.locations) {
          if (location['label'] == alertCity) {
            migunTime = location['migun_time'];
            cityData.add(location);
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
