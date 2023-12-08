import 'package:flutter/material.dart';
import 'package:red_alert_test_android/models/area.dart';
import 'area_selection_screen.dart'; // Import the screen where areas are selected

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
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            spacing: 10.0, // Set the spacing between chips
            runSpacing: 10.0, // Set the spacing between rows
            children: [
              InkWell(
                onTap: () {
                  // Navigate back to the area selection screen
                  Navigator.of(context).pop();
                },
                child: Chip(
                  label: const Text(
                    'הוספה',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              for (final area in selectedAreas)
                Chip(
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
            ],
          ),
        ),
      ),
    );
  }
}
