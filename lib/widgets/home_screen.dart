import 'package:flutter/material.dart';
import 'package:red_alert_test_android/models/area.dart';

import '../logic/red_alert.dart';

class HomeScreen extends StatefulWidget {
  final List<Area> selectedAreas;

  HomeScreen(this.selectedAreas);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late RedAlert redAlert;

  @override
  void initState() {
    super.initState();
    redAlert =
        RedAlert(widget.selectedAreas, onAlarmActivated: updateUIOnAlarm);
  }

  void updateUIOnAlarm() {
    if (mounted) {
      setState(() {
        // Update UI here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('אזעקת אמת'),
        ),
        body: Padding(
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
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.blue.withOpacity(0.7)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(8.0)),
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
                for (final area in widget.selectedAreas)
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Chip(
                      label: Text(
                        area.labelHe ?? area.label ?? area.areaName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.orange.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
