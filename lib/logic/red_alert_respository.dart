import 'package:red_alert_test_android/logic/red_alert.dart';

import '../models/alert.dart';
import '../models/alert_category.dart';
import '../models/area.dart';

abstract class RedAlertRepository {

  List<Area> selectedAreas = [];

  Future<List<AlertModel>> getRedAlertsHistory();

  Future<Map<String, dynamic>?> getRedAlerts();

  Future<List<AlertCategory>> getAlertCategories();

  void cancelTimer();

  void setOnAlarmActivated(AlarmCallback? onAlarmActivated);

  void setSelectedAreas(List<Area> selectedAreas);
}