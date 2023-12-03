import 'dart:async';
import 'package:red_alert_test/logic/red_alert.dart';

/// Main entry point of the application.
Future<void> main() async {
  final alert = RedAlert();

  while (true) {
    final alertData = <String, dynamic>{};
    final cityData = <Map<String, dynamic>>[];
    var migunTime = 0;

    await Future.delayed(Duration(seconds: 45));
    print("[-] Searching for alerts ...");

    final redAlerts = await alert.getRedAlerts();

    if (redAlerts != null) {
      for (final alertCity in redAlerts["data"]) {
        final alertId = redAlerts["id"];
        for (final location in alert.locations) {
          if (location["label"] == alertCity) {
            migunTime = location["migun_time"];
            cityData.add(location);
          }
        }
        redAlerts["cities_labels"] = cityData;
        redAlerts["time_to_run"] = migunTime;

        // Do whatever you need to do with the data
        print("cityData.length is" + cityData.length.toString());
        print("migunTime is" + migunTime.toString());
      }
    } else {
      print("[-] No alerts for now, keep checking ...");
    }
  }
}
