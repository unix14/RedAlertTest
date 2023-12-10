import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common/date_extensions.dart';
import '../common/extensions.dart';
import '../common/styles.dart';
import '../logic/red_alert.dart';
import '../main.dart';
import '../models/alert_model.dart';
import '../models/area.dart';
import 'area_selection_screen.dart';

class MainAlertScreen extends StatefulWidget {

  final List<Area> selectedAreas;

  MainAlertScreen(this.selectedAreas);

  @override
  _MainAlertScreenState createState() => _MainAlertScreenState();
}

class _MainAlertScreenState extends State<MainAlertScreen> {
  late RedAlert redAlert;
  List<Map<String, dynamic>> alertData = []; // List to hold alert data

  @override
  void initState() {
    super.initState();
    redAlert =
        RedAlert(widget.selectedAreas, onAlarmActivated: updateUIOnAlarm);
    fetchAlertData(); // Fetch alert data when the screen initializes
  }

  void fetchAlertData() async {
    final data = await redAlert.getRedAlerts();
    if (data != null) {
      setState(() {
        alertData = List.from(data['data']);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    redAlert.cancelTimer();
  }

  void updateUIOnAlarm() {
    if (mounted) {
      setState(() {
        // Update UI here
        //Todo add a ui to the screen and update it here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 10.0,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextButton(
                    onPressed: () {
                      // Navigate back to the area selection screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AreaSelectionScreen(
                            areas: areas,
                            selectedAreas: widget.selectedAreas.toList(),
                          ),
                        ),
                      );
                    },
                    style: kBlueButtonStyle.copyWith(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(15.0),
                      ),
                    ),
                    child: const Text(
                      'הוספת איזורי התראה',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                for (final area in widget.selectedAreas) createAreaChip(area, null),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(18.0),
          child: Text(
            'התראות אחרונות:', // Text for the section heading
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<AlertModel>>(
            future: redAlert.getRedAlertsHistory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: SizedBox(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final alerts = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
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
        ),
      ],
    );
  }
}