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
