import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../common/constants.dart';
import '../common/red_alert_logger.dart';

class RedAlert {
  late List<Map<String, dynamic>> locations;
  late String cookies;
  late Map<String, String> headers;

  RedAlert(){
    // locations = getLocationsList();
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
    const host = RedAlertConstants.host;
    final response = await http.get(Uri.parse(host), headers: headers);
    cookies = response.headers["set-cookie"] ?? "";
  }

  int getAlertCount(Map<String, dynamic> alertsData) {
    return (alertsData["data"] as List).length;
  }

  List<Map<String, dynamic>> getLocationsList() {
    final file = File('assets/targets.json');

    // RedAlertLogger.logInfo('Current working directory: ${Directory.current.path}');

    try {
      if (file.existsSync()) {
        // File exists, proceed with reading.
        // Your code to read the file goes here.
        final jsonString = file.readAsStringSync(encoding: utf8);
        final jsonMap = jsonDecode(jsonString);
        final List<Map<String, dynamic>> locationsList = [];

        jsonMap.forEach((key, value) {
          final locationData = Map<String, dynamic>.from(value);
          locationsList.add(locationData);
        });

        return locationsList;
      } else {
        RedAlertLogger.logError('Error: File not found. ${file.path}');
      }
    } catch (e) {
      RedAlertLogger.logError('Error reading JSON file: $e');
    }

    return []; // Return an empty list or handle the error as needed
  }

  Future<Map<String, dynamic>?> getRedAlerts() async {
    const host = RedAlertConstants.alertsEndpoint;

    final response = await http.get(Uri.parse(host), headers: headers);
    final String responseBody = response.body;
    final alerts = responseBody.replaceAll("\n", "").replaceAll("\r", "");

    // Remove BOM and other non-RedAlertLogger.logInfoable characters
    final cleanAlerts = alerts.replaceAll(RegExp('[^ -~]+'), '');

    if (cleanAlerts.isEmpty) {
      return null;
    }

    // Decode the response using UTF-8 encoding
    const utf8Decoder = Utf8Decoder(allowMalformed: true);
    final cleanedResponse = utf8Decoder.convert(responseBody.codeUnits);

    RedAlertLogger.logInfo('[-] Showing cleanedResponse ...$cleanedResponse');

    final Map<String, dynamic> json = jsonDecode(cleanedResponse);
    if ((json["data"] as List).isEmpty) {
      return null;
    }

    json["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    return json;
  }
}
