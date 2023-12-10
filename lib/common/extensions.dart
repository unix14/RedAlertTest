import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/area.dart';

typedef AreaCallback = void Function(Area area);

extension SetToggle<T> on Set<T> {
  void toggle(T element) {
    contains(element) ? remove(element) : add(element);
  }
}

Widget createAreaChip(Area area, AreaCallback? onDelete) {
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
        onDeleted: onDelete != null ? () {
          onDelete(area);
        } : null,
        backgroundColor: Colors.orange.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );
}