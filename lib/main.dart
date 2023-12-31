import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_alert_test_android/widgets/area_selection_screen.dart';
import 'package:red_alert_test_android/widgets/home_screen.dart';

import 'models/area.dart';
import 'package:window_manager/window_manager.dart';

//think about how to make it singleton and injectable and approachable from different screens.
List<Area> areas = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initPcWindow();

  String jsonString = await rootBundle.loadString('assets/targets.json');
  // Map<String, dynamic> jsonData = json.decode(jsonString);

  // Decode the JSON data as a Map<String, dynamic>
  Map<String, dynamic> jsonData = json.decode(jsonString);

  // Extract values as a List<dynamic>
  List<dynamic> jsonList = jsonData.values.toList();

  // Convert the List<dynamic> to a List<Area>
  areas = jsonList.map((json) => Area.fromJson(json)).toList();

  //todo load from shared prefs the areas
  //find a way to save data fetched from server in cache as long as possible, for example alerts history and category ids


  // Create an instance of MyApp with the loaded data
  MyApp myApp = MyApp(areas);

  // Run the application with MyApp instance
  runApp(myApp);
}

Future<void> initPcWindow() async {
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(420, 1000),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
    fullScreen: false,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();

    windowManager.setResizable(false);
    windowManager.setFullScreen(false);
    // windowManager.setOpacity(0.2);
    // windowManager.setPreventClose(true); // see usage on main alert screen
    // windowManager.setVisibleOnAllWorkspaces(true);
    // windowManager.setMovable(false);
  });
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Red Alert',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  final List<Area> areas;

  MyApp(this.areas);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shield On',
      debugShowCheckedModeBanner: false,
      // home: TestScreen(),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: AreaSelectionScreen(areas: areas)),
          // child: HomeScreen([])),
    );
  }
}

class TestScreen extends StatelessWidget {
  // final RedAlert redAlert = RedAlert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Screen'),
      ),
      // body: FutureBuilder(
      //   future: redAlert.getRedAlerts(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // Process and display the details of the response
      //       final responseDetails = buildResponseDetails(snapshot.data ?? Map());
      //       return Center(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             const Text(
      //               'Response Details:',
      //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //             ),
      //             const SizedBox(height: 20),
      //             Text(responseDetails),
      //           ],
      //         ),
      //       );
      //     } else if (snapshot.hasError) {
      //       return Center(
      //         child: Text('Error: ${snapshot.error}'),
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
    );
  }

  String buildResponseDetails(Map<String, dynamic> response) {
    // Customize how you want to display the details
    return response.toString();
  }
}
