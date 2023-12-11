import 'package:flutter/material.dart';

ButtonStyle kBlueButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  padding:
      MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(8.0)),
);

ButtonStyle kGreyButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  padding:
  MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(8.0)),
);

Icon homeIcon = Icon(Icons.home);
Icon notificationsIcon = Icon(Icons.notifications);
Icon settingsIcon = Icon(Icons.settings);

const Color kOrangeColor = Color.fromARGB(255, 247, 124, 50);

Widget kProgressBar = const Center(
    child: SizedBox(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue))));