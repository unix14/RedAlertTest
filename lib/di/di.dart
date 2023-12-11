import 'package:get_it/get_it.dart';
import 'package:red_alert_test_android/logic/red_alert.dart';
import '../logic/red_alert_respository.dart';

class DI  {

  final locator = GetIt.instance;
  static bool _isInitialized = false;

  DI._();

  static T getSingleton<T extends Object>() {
    return _instance.get<T>();
  }

  static init() {
    _instance;
  }

  static GetIt get _instance {
    if (!_isInitialized) {
      _setupLocator();
    }
    return GetIt.instance;
  }

  static void _setupLocator() {
    _isInitialized = true;

    //Init singletons
    _instance.registerLazySingleton<RedAlertRepository>(() => _initRedAlertRepo());
  }

  static RedAlertRepository _initRedAlertRepo() {
    return RedAlert();
  }
}