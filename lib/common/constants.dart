class RedAlertConstants {
  static const String host = "https://www.oref.org.il";
  static const String suffix = "/WarningMessages/alert/alerts.json";
  static const String alertsEndpoint = "$host$suffix";

  static const String historyUrl = 'https://www.oref.org.il/WarningMessages/History/AlertsHistory.json';

  static const int MAX_ALERT_AREAS_POSSIBLE = 6;
  static const String MAXIMUM_ALERT_MESSAGE = 'ניתן לבחור עד $MAX_ALERT_AREAS_POSSIBLE איזורי התראה שונים';
// Add other constants as needed
}