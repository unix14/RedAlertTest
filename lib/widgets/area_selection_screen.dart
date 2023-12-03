import 'package:flutter/material.dart';
import 'package:red_alert_test/models/area.dart';

class AreaSelectionScreen extends StatelessWidget {
  final List<Area> areas;

  AreaSelectionScreen({required this.areas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Area'),
      ),
      body: ListView.builder(
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          return ListTile(
            title: Text(area.name),
            onTap: () {
              // TODO: Navigate to the main screen with the selected area
            },
          );
        },
      ),
    );
  }
}
