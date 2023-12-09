import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_alert_test_android/widgets/area_selection_screen.dart';

import 'logic/red_alert.dart';
import 'models/area.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String jsonString = await rootBundle.loadString('assets/targets.json');
  // Map<String, dynamic> jsonData = json.decode(jsonString);

  // Decode the JSON data as a Map<String, dynamic>
  Map<String, dynamic> jsonData = json.decode(jsonString);

  // Extract values as a List<dynamic>
  List<dynamic> jsonList = jsonData.values.toList();

  // Convert the List<dynamic> to a List<Area>
  List<Area> areas = jsonList.map((json) => Area.fromJson(json)).toList();


  print('JSON Data: $jsonList');


  // Create an instance of MyApp with the loaded data
  MyApp myApp = MyApp(areas);

  // Run the application with MyApp instance
  runApp(myApp);
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
      title: 'Red Alert Test',
      // home: HomeScreen(), // todo fix issues here
      // home: TestScreen(),
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: AreaSelectionScreen(areas: areas)),
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
