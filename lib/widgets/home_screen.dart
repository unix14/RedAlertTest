import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:red_alert_test/models/area.dart';
import 'area_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Load areas from the JSON file
      future: DefaultAssetBundle.of(context).loadString('assets/data/targets.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final Map<String, dynamic> targetsData = json.decode(snapshot.data.toString());
          final List<Area> areas = targetsData.values.map((target) => Area.fromJson(target)).toList();

          return AreaSelectionScreen(areas: areas);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}