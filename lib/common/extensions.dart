import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/area.dart';

Widget createAreaChip(Area area, VoidCallback? onDelete) {
  //todo add on click? to home screen panel?
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Chip(
        label: Text(
          area.labelHe ?? area.label ?? area.areaName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        deleteButtonTooltipMessage: "הסרה",
        deleteIconColor: Colors.white,
        onDeleted: onDelete,
        backgroundColor: Colors.orange.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );
}