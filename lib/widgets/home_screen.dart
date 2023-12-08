import 'package:flutter/material.dart';
import 'package:red_alert_test_android/models/area.dart';

import '../common/styles.dart';
import 'area_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Area> selectedAreas;

  HomeScreen(this.selectedAreas);

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
                TextButton(
                  onPressed: () {
                    // Navigate back to the area selection screen
                    Navigator.of(context).pop();
                  },
                  style: kBlueButtonStyle,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'הוספת איזורי התראה',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                for (final area in selectedAreas)
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
