import 'package:flutter/material.dart';
import 'package:red_alert_test_android/common/styles.dart';
import 'package:red_alert_test_android/logic/red_alert_respository.dart';
import "package:webview_universal/webview_universal.dart";

import '../models/alert.dart';
import '../models/alert_category.dart';
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
        onDeleted: onDelete != null
            ? () {
                onDelete(area);
              }
            : null,
        backgroundColor: kOrangeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );
}

Widget buildRedAlertsHistoryList(RedAlertRepository redAlert,
    {int maximumItems = -1, GestureTapCallback? onReadMoreClicked}) {
  return Expanded(
    child: FutureBuilder<List<AlertModel>>(
      future: redAlert.getRedAlertsHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return kProgressBar;
        } else if (snapshot.hasError) {
          return Text('שגיאה: ${snapshot.error}');
        } else {
          final alerts = snapshot.data ?? [];
          return ListView.builder(
            itemCount: maximumItems > -1 ? maximumItems + 1 : alerts.length + 1,
            itemBuilder: (context, index) {
              if (index == maximumItems || index == alerts.length) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
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
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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

Widget buildAlertCategoriesList(RedAlertRepository redAlert) {
  final PageController _pageController = PageController(viewportFraction: 0.8);

  return FutureBuilder<List<AlertCategory>>(
    future: redAlert.getAlertCategories(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return kProgressBar;
      } else if (snapshot.hasError) {
        return Center(child: Text('שגיאה: ${snapshot.error}'));
      } else {
        // Use the data to build your UI
        final categories = snapshot.data!;
        return Column(
          children: [
            SizedBox(
              height: 195,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return GestureDetector(
                        onTap: () {
                          openWebLink(context, category.link);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 4,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                                  child: SizedBox(
                                    width: 100,
                                    child: Image.network(
                                      "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Bahad16.png/142px-Bahad16.png",
                                      // Replace with the actual URL
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          category.label,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 140,
                                            child: Text(category.description)),
                                        const SizedBox(height: 8),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              openWebLink(
                                                  context, category.link);
                                            },
                                            child: const Text('למידע נוסף',
                                                style: TextStyle(
                                                    color: Colors.blue)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 16,
                    top: 80,
                    child: Card(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInCubic,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    top: 80,
                    child: Card(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInCubic,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    },
  );
}

Future<void> openWebLink(BuildContext context, String link) async {
  WebViewController webViewController = WebViewController();

  await webViewController.init(
    context: context,
    uri: Uri.parse(link),
    setState: (void Function() fn) {
      //todo figure out why we need this
      // Navigator.pop(context);
    },
  );
  WebView(
    controller: webViewController,
  );
}
