import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

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

  Future<void> getCookies() async {
    final host = "https://www.oref.org.il/";
    final response = await http.get(Uri.parse(host), headers: headers);
    cookies = response.headers["set-cookie"] ?? "";
  }

  Future<Map<String, dynamic>> getCoordinates(String locationName) async {
    final host =
        "https://maps.google.com/maps/api/geocode/json?address=$locationName";
    final response = await http.get(Uri.parse(host), headers: headers);
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json["results"][0]["geometry"]["location"];
  }

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
    final host = "https://www.oref.org.il/WarningMessages/alert/alerts.json";
    final response = await http.get(Uri.parse(host), headers: headers);
    final alerts = response.body.replaceAll("\n", "").replaceAll("\r", "");
    if (alerts.length <= 1) {
      return null;
    }

    print("[-] Showoing response ..." + response.body);

    final Map<String, dynamic> json = jsonDecode(response.body);
    if ((json["data"] as List).isEmpty) {
      return null;
    }

    json["timestamp"] = DateTime.now().millisecondsSinceEpoch;
    return json;
  }
}

Future<void> main() async {
  final alert = RedAlert();

  while (true) {
    final alertData = <String, dynamic>{};
    final cityData = <Map<String, dynamic>>[];
    var migunTime = 0;

    await Future.delayed(Duration(seconds: 1));
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
