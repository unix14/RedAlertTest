

import '../models/alert.dart';
import '../models/area.dart';

abstract class RedAlertRepository {

  List<Area> selectedAreas = [];

  Future<List<AlertModel>> getRedAlertsHistory();

  Future<Map<String, dynamic>?> getRedAlerts();

  void cancelTimer();

  void setSelectedAreas(List<Area> selectedAreas);
}