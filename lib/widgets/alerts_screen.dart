import 'package:flutter/material.dart';

import '../common/constants.dart';
import '../common/extensions.dart';
import '../di/di.dart';
import '../logic/red_alert_respository.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen();

  @override
  _AlertsScreenState createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final RedAlertRepository _redAlertRepo = DI.getSingleton<RedAlertRepository>();

  @override
  Widget build(BuildContext context) {
    return buildRedAlertsHistoryList(_redAlertRepo, onReadMoreClicked: () {
      openWebLink(context, RedAlertConstants.allAlertsUrl);
    });
    //todo add more widgets here to filter by dates.
    // use links :
    // https://www.oref.org.il//Shared/Ajax/GetAlarmsHistory.aspx?lang=he&fromDate=28.11.1994&toDate=05.12.2023&mode=3
    // mode can be 0 1 or 2 , play with it until understood
  }
}
