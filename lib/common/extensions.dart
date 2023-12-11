import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_alert_test_android/common/styles.dart';
import '../logic/red_alert.dart';
import '../models/alert.dart';
import '../models/area.dart';
import 'date_extensions.dart';

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

Widget buildRedAlertsHistoryList(RedAlert redAlert, { int maximumItems = -1, GestureTapCallback? onReadMoreClicked}) {
  return Expanded(
    child: FutureBuilder<List<AlertModel>>(
      future: redAlert.getRedAlertsHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SizedBox(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          return Text('שגיאה: ${snapshot.error}');
        } else {
          final alerts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: maximumItems > -1 ? maximumItems + 1 : alerts.length,
            itemBuilder: (context, index) {
              if(index == maximumItems) {
                return GestureDetector(
                  onTap: onReadMoreClicked,
                  child: const Center(
                    child: Text(
                      'לכל ההתראות', // Text for the section heading
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dotted,
                        color: Colors.blue,
                        decorationColor: Colors.blue,
                      ),
                    ),
                  ),
                );
              }
              final alert = alerts[index];
              //todo implement on click events??
              return Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.data,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          alert.title,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // todo format date
                        Text(getFormattedDate(alert.alertDate)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    ),
  );
}