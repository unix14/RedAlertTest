import '../models/alert.dart';
import '../models/alert_category.dart';
import '../models/area.dart';

abstract class RedAlertRepository {

  List<Area> selectedAreas = [];

  Future<List<AlertModel>> getRedAlertsHistory();

  Future<Map<String, dynamic>?> getRedAlerts();

  Future<List<AlertCategory>> getAlertCategories();

  void cancelTimer();

  void setSelectedAreas(List<Area> selectedAreas);
}