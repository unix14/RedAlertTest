import 'package:flutter/material.dart';
import 'package:red_alert_test/models/alert.dart';

class AlertWidget extends StatelessWidget {
  final Alert alert;

  AlertWidget({this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(alert.message),
        // Add more details or actions as needed
      ),
    );
  }
}