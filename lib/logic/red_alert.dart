import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
// import 'package:http/browser_client.dart' as http;
import 'package:red_alert_test_android/logic/red_alert_respository.dart';

import '../common/constants.dart';
import '../custom/red_alert_logger.dart';
import '../models/alert.dart';
import '../models/alert_category.dart';
import '../models/area.dart';

typedef AlarmCallback = Function();


class RedAlert implements RedAlertRepository {
  @override
  late List<Area> selectedAreas;

  late Map<String, String> headers;

  late AlarmCallback? onAlarmActivated;
  late bool isAlarmActive;
  late Timer alertCheckTimer;

  RedAlert() {
    isAlarmActive = false;
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

    // Initialize the timer for periodic alert checks
    alertCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // Check for new alerts
      final alertsData = await getRedAlerts();
      if (alertsData != null) {
        final alertCount = getAlertCount(alertsData);
        if (alertCount > 0) {
          //todo check if alarm is going in one of the selectedAreas
          activateAlarm();
        }
      }
    });
  }

  @override
  void setOnAlarmActivated(AlarmCallback? onAlarmActivated) {
    this.onAlarmActivated = onAlarmActivated;
  }

  @override
  void setSelectedAreas(List<Area> selectedAreas) {
    //todo remove this function if is not needed in the actual alert endpoint
    // maybe use it on somewhere else \ settings screen
    this.selectedAreas = selectedAreas;
  }

  @override
  void cancelTimer() {
    alertCheckTimer.cancel();
    //todo fix cancel timer does not stop when leaving the screen
  }

  int getAlertCount(Map<String, dynamic> alertsData) {
    return alertsData.isNotEmpty ? (alertsData["data"] as List).length : 0;
  }

  @override
  Future<List<AlertCategory>> getAlertCategories() async {
    try {
      // Replace this URL with the actual API endpoint
      final response = await http.get(Uri.parse(RedAlertConstants.alertCategoriesUrl));

      if (response.statusCode == 200) {
        // Decode the response using UTF-8 encoding
        //todo make this as an http repository
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        final cleanedResponse = utf8Decoder.convert(response.body.codeUnits);

        final List<dynamic> jsonList = json.decode(cleanedResponse);
        return jsonList.map((json) => AlertCategory.fromJson(json)).toList();
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load alert categories');
      }
    } catch (e) {
      RedAlertLogger.logError('Error in getAlertCategories: ${e.hashCode} ${e.runtimeType} $e');
      // Use stub data in case of network error or empty results
      return RedAlertConstants.alertCategoriesData;
    }
  }

  @override
  Future<List<AlertModel>> getRedAlertsHistory() async {
    try {
      final Uri uri = Uri.parse(RedAlertConstants.historyUrl);
      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Decode the response using UTF-8 encoding
        const utf8Decoder = Utf8Decoder(allowMalformed: true);
        final cleanedResponse = utf8Decoder.convert(response.body.codeUnits);

        final List<dynamic> jsonList = jsonDecode(cleanedResponse);
        final List<AlertModel> alertList = jsonList.map((json) => AlertModel.fromJson(json)).toList();
        return alertList;
      } else {
        RedAlertLogger.logError('Non-200 status code: ${response.statusCode}');
        RedAlertLogger.logInfo('Non-200 response body:\n${response.body}');
        return [];
      }
    } catch (e, stackTrace) {
      RedAlertLogger.logError('Error in getRedAlerts: ${e.hashCode} ${e.runtimeType} $e\n$stackTrace');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>?> getRedAlerts() async {
    const host = RedAlertConstants.alertsEndpoint;

    try {
      final Uri uri = Uri.parse(host);

      //todo think about diffrentiation between mobile and chrome\web
      final response = await http.get(uri, headers: headers);
      //todo think about deploying cloud function to firebase that will do the operation and will update the results into firestore
      //todo then here implement firestore listening

      if (response.statusCode == 200) {
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
      } else {
        // Handle non-200 status code
        RedAlertLogger.logError('Non-200 status code: ${response.statusCode}');
        RedAlertLogger.logInfo('Non-200 response body:\n${response.body}');
        return null; // or throw an exception if necessary
      }
    } catch (e, stackTrace) {
      // Handle the error, log it, or return a specific value
      RedAlertLogger.logError('Error in getRedAlerts: ${e.hashCode} ${e.runtimeType} $e\n$stackTrace');
      return null; // or throw the error again if necessary
    }
  }

  void activateAlarm() {
    if (!isAlarmActive) {
      // Set the alarm active flag to true
      isAlarmActive = true;

      // Trigger the callback function provided by HomeScreen
      onAlarmActivated??();

      // Set a timer for 10 minutes (600 seconds)
      Timer(const Duration(minutes: 10), () {
        // When the timer expires, reset the alarm flag
        if (isAlarmActive) {
          // Check if the alarm is still active before resetting
          isAlarmActive = false;

          //todo remove duplicate call here?
          // Trigger the callback function provided by HomeScreen to reset UI
          onAlarmActivated??();
          //todo add response from RedAlert code into home screen callabck
        }
      });
    }
  }

}
