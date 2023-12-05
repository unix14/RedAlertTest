import 'package:flutter/material.dart';
import 'logic/red_alert.dart';
import 'widgets/home_screen.dart';

void main() {
  runApp(MyApp());
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Alert Test',
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final RedAlert redAlert = RedAlert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: FutureBuilder(
        future: redAlert.getRedAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Process and display the details of the response
            final responseDetails = buildResponseDetails(snapshot.data);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Response Details:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(responseDetails),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String buildResponseDetails(Map<String, dynamic> response) {
    // Customize how you want to display the details
    return response.toString();
  }
}
