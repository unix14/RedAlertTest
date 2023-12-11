import 'package:flutter/material.dart';
import 'package:red_alert_test_android/models/area.dart';
import 'package:red_alert_test_android/widgets/alerts_screen.dart';
import 'package:red_alert_test_android/widgets/main_alert_screen.dart';
import 'package:red_alert_test_android/widgets/settings_screen.dart';
import '../common/styles.dart';

class HomeScreen extends StatefulWidget {
  final List<Area> selectedAreas;

  HomeScreen(this.selectedAreas);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _pages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = [
      MainAlertScreen(widget.selectedAreas),
      /// todo find a way to inject it once again here. maybe use publ;ic variable?? also shuld be fetched from shared prefs at some point
      const AlertsScreen(),
      SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('אזעקת אמת'),
          ),
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: homeIcon,
                  activeIcon: Icon(
                    homeIcon.icon,
                    color: Colors.blue,
                  ),
                  label: 'ראשי',
                  tooltip: 'ראשי',
                ),
                BottomNavigationBarItem(
                  icon: notificationsIcon,
                  activeIcon: Icon(
                    notificationsIcon.icon,
                    color: Colors.blue,
                  ),
                  label: 'התראות',
                  tooltip: 'התראות',
                ),
                BottomNavigationBarItem(
                  icon: settingsIcon,
                  activeIcon: Icon(
                    settingsIcon.icon,
                    color: Colors.blue,
                  ),
                  label: 'הגדרות',
                  tooltip: 'הגדרות',
                ),
              ])),
    );
  }
}

//todo make settings page with different languages english\hebrew