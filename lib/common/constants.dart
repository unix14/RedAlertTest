import '../models/alert_category.dart';

class RedAlertConstants {
  static const String host = "https://www.oref.org.il";
  static const String suffix = "/WarningMessages/alert/alerts.json";
  static const String alertsEndpoint = "$host$suffix";

  static const String historyUrl = '$host/WarningMessages/History/AlertsHistory.json';
  static const String alertCategoriesUrl = '$host/Leftovers/HE.Leftovers.json';

  static const int MAX_ALERT_AREAS_POSSIBLE = 6;
  static const String MAXIMUM_ALERT_MESSAGE = 'ניתן לבחור עד $MAX_ALERT_AREAS_POSSIBLE איזורי התראה שונים';


  static List<AlertCategory> alertCategoriesData = [
    AlertCategory(
      category: 1,
      label: 'ירי רקטות וטילים',
      description: 'היכנסו למרחב המוגן ושהו בו 10 דקות',
      link: 'https://www.oref.org.il/12943-he/pakar.aspx',
    ),
    AlertCategory(
      category: 2,
      label: 'חדירת כלי טיס עוין',
      description: 'היכנסו מיד למרחב המוגן ושהו בו למשך 10 דקות, אלא אם ניתנה התרעה נוספת',
      link: 'https://www.oref.org.il/12754-he/pakar.aspx',
    ),
    AlertCategory(
      category: 7,
      label: 'רעידת אדמה',
      description: 'צאו מיד לשטח פתוח. אם לא ניתן, היכנסו לממ"ד או לחדר מדרגות',
      link: 'https://www.oref.org.il/12765-he/pakar.aspx',
    ),
    AlertCategory(
      category: 8,
      label: 'רעידת אדמה',
      description: 'צאו מיד לשטח פתוח. אם לא ניתן, היכנסו לממ"ד או לחדר מדרגות',
      link: 'https://www.oref.org.il/12765-he/pakar.aspx',
    ),
    AlertCategory(
      category: 9,
      label: 'אירוע רדיולוגי',
      description: 'היכנסו למבנה וסגרו את הדלתות והחלונות',
      link: 'https://www.oref.org.il/12756-he/pakar.aspx',
    ),
    AlertCategory(
      category: 10,
      label: 'חדירת מחבלים',
      description: 'היכנסו מיד למבנה, נעלו את הדלתות וסגרו את החלונות',
      link: 'https://www.oref.org.il/12757-he/pakar.aspx',
    ),
    AlertCategory(
      category: 11,
      label: 'צונאמי',
      description: 'התרחקו מיד מחוף הים קילומטר אחד לפחות או עלו לקומה רביעית ומעלה',
      link: 'https://www.oref.org.il/12764-he/pakar.aspx',
    ),
    AlertCategory(
      category: 12,
      label: 'אירוע חומרים מסוכנים',
      description: 'היכנסו מיד למבנה וסגרו את הדלתות והחלונות',
      link: 'https://www.oref.org.il/12759-he/pakar.aspx',
    ),
  ];
// Add other constants as needed
}