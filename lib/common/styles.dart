import 'package:flutter/material.dart';

ButtonStyle kBlueButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  padding:
      MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8.0)),
);

ButtonStyle kGreyButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  padding:
  MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8.0)),
);
