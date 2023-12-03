import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../common/constants.dart';
import '../common/red_alert_logger.dart';

class RedAlert {
  List<Map<String, dynamic>> locations;
  String cookies;
  Map<String, String> headers;

  RedAlert() {
    locations = getLocationsList();
    cookies = "";
    headers = {
      "Host": "www.oref.org.il",
      "Connection": "keep-alive",
      "Content-Type": "application/json;charset=UTF-8",
      "charset": "utf-8",
      "X-Requested-With": "XMLHttpRequest",
      "sec-ch-ua-mobile": "?0",
      "User-Agent": "",
      "sec-ch-ua-platform": "macOS",
      "Accept": "*/*",
      "sec-ch-ua":
      '".Not/A)Brand"v="99", "Google Chrome";v="103", "Chromium";v="103"',
      "Sec-Fetch-Site": "same-origin",
      "Sec-Fetch-Mode": "cors",
      "Sec-Fetch-Dest": "empty",
      "Referer": "https://www.oref.org.il/12481-he/Pakar.aspx",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7",
    };

    getCookies();
  }

  /// Fetches cookies from the host.
  Future<void> getCookies() async {
    final host = RedAlertConstants.host;
    final response = await http.get(Uri.parse(host), headers: headers);
    cookies = response.headers["set-cookie"] ?? "";
  }

  /// Fetches coordinates for a given location name using Google Maps API.
  Map<String, dynamic> randomCoordinates(double latitude, double longitude) {
    final circleR = 1.0;
    final circleX = latitude;
    final circleY = longitude;
    final alpha = 2 * pi * Random().nextDouble();
    final r = circleR * Random().nextDouble();
    final x = r * cos(alpha) + circleX;
    final y = r * sin(alpha) + circleY;
    return {"latitude": x, "longitude": y};
  }

  int countAlerts(Map<String, dynamic> alertsData) {
    return (alertsData["data"] as List).length;
  }

  List<Map<String, dynamic>> getLocationsList() {
    final file = 'targets.json';
    final jsonString = '{"locations": []}'; // Replace with your JSON content
    final jsonMap = jsonDecode(jsonString);
    return List<Map<String, dynamic>>.from(jsonMap["locations"]);
  }

  Future<Map<String, dynamic>> getRedAlerts() async {
    final host = RedAlertConstants.alertsEndpoint;

    final response = await http.get(Uri.parse(host), headers: headers);
    RedAlertLogger.logInfo('[-] Showing response ...' + response.body);
    final alerts = response.body.replaceAll("\n", "").replaceAll("\r", "");

    // Remove BOM and other non-RedAlertLogger.logInfoable characters
    final cleanAlerts = alerts.replaceAll(RegExp('[^ -~]+'), '');

    if (cleanAlerts.isEmpty) {
      return null;
    }

    RedAlertLogger.logInfo('[-] Showing Alerts!!!! ...' + cleanAlerts);

    final Map<String, dynamic> json = jsonDecode(cleanAlerts);
    if ((json["data"] as List).isEmpty) {
      return null;
    }

    json["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    return json;
  }
}
