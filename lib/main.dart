import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:red_alert_test/models/alert.dart';
import 'package:red_alert_test/models/area.dart';
import 'ppackage:red_alert_test/models/main_screen.dart';
import 'ppackage:red_alert_test/models/area_selection_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Load areas from the JSON file
      future: DefaultAssetBundle.of(context).loadString('assets/data/areas.json'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<dynamic> areasData = json.decode(snapshot.data.toString());
          final List<Area> areas = areasData.map((area) => Area(area['name'])).toList();

          return AreaSelectionScreen(areas: areas);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}