import 'package:flutter/material.dart';
import 'package:red_alert_test_android/common/constants.dart';
import 'package:red_alert_test_android/logic/red_alert_respository.dart';
import 'package:window_manager/window_manager.dart';
import '../common/extensions.dart';
import '../common/styles.dart';
import '../di/di.dart';
import '../main.dart';
import '../models/area.dart';
import 'area_selection_screen.dart';

class MainAlertScreen extends StatefulWidget {

  final List<Area> selectedAreas;

  MainAlertScreen(this.selectedAreas);

  @override
  _MainAlertScreenState createState() => _MainAlertScreenState();
}

class _MainAlertScreenState extends State<MainAlertScreen> with WindowListener {
  final RedAlertRepository _redAlertRepo = DI.getSingleton<RedAlertRepository>();
  List<Map<String, dynamic>> alertData = []; // List to hold alert data

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _redAlertRepo.setSelectedAreas(widget.selectedAreas);
    //todo bring back using the callback updateUIOnAlarm
    // redAlert =
    //     RedAlert(widget.selectedAreas, onAlarmActivated: updateUIOnAlarm);
    fetchAlertData(); // Fetch alert data when the screen initializes
    _initWindow();
  }

  void _initWindow() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text('האם לסגור את שילד און?'),
            actions: [
              TextButton(
                child: const Text('לא'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('כן'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
  }

  void fetchAlertData() async {
    final data = await _redAlertRepo.getRedAlerts();
    if (data != null) {
      setState(() {
        alertData = List.from(data['data']);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _redAlertRepo.cancelTimer();
    windowManager.removeListener(this);
  }

  void updateUIOnAlarm() {
    if (mounted) {
      setState(() {
        // Update UI here
        //Todo add a ui to the screen and update it here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextButton(
                      onPressed: () {
                        // Navigate back to the area selection screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AreaSelectionScreen(
                              areas: areas,
                              selectedAreas: widget.selectedAreas.toList(),
                            ),
                          ),
                        );
                      },
                      style: kBlueButtonStyle.copyWith(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(15.0),
                        ),
                      ),
                      child: const Text(
                        'הוספת איזורי התראה',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  for (final area in widget.selectedAreas) createAreaChip(area, null),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 18, top: 18),
            child: Text(
              'הנחיות מצילות חיים', // Text for the section heading
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          buildAlertCategoriesList(_redAlertRepo),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              'התראות אחרונות', // Text for the section heading
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          buildRedAlertsHistoryList(_redAlertRepo, maximumItems: 5, onReadMoreClicked: () {
            openWebLink(context, RedAlertConstants.allAlertsUrl);
            //todo think about some navigation component that will handle all of the navigation in the app
            // setState(() {
            //   _currentTabIndex = 2;
            // });
          }),
        ],
      ),
      floatHeaderSlivers: false,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [];
    },
    );
  }
}