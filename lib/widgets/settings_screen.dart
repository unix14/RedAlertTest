import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool automaticAlertUpdates = true;
  String selectedAlertSound = 'צליל התראה';
  double selectedAlertSoundLevel = 0.5;
  String selectedLanguage = 'עברית'; // Assuming 'hebrew' is the default
  String aboutItemClicked = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildSettingsGroup(
            'כללי',
            [
              _buildSwitchTile('הפעלת עדכונים אוטומטית', automaticAlertUpdates),
              // Add more general settings here
            ],
          ),
          _buildSettingsGroup(
            'צליל',
            [
              _buildSelectTile('בחר צליל התראה', selectedAlertSound),
              // _buildSliderTile('בחר רמת קול של צליל התראה', selectedAlertSoundLevel),
              // Add more audio settings here
            ],
          ),
          _buildSettingsGroup(
            'שפה',
            [
              _buildRadioTile('עברית', 'עברית', selectedLanguage == 'עברית'),
              _buildRadioTile('English', 'english', selectedLanguage == 'english'),
              // Add more language settings here
            ],
          ),
          _buildSettingsGroup(
            'אודות',
            [
              //todo put links here
              _buildAboutTile('אודות האפליקציה'),
              _buildAboutTile('אודות המפתח'),
              _buildAboutTile('דרגו אותנו בחנות'),
              _buildSelectTile('צור קשר', "support@3p-cups.com"),
              _buildSelectTile('גרסה', "v1.010.5c"), //todo enter version code
              // Add more about settings here
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...settings,
        const Divider(),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: (bool newValue) {
          setState(() {
            automaticAlertUpdates = newValue;
          });
        },
      ),
    );
  }

  Widget _buildSelectTile(String title, String selectedValue) {
    return ListTile(
      title: Text(title),
      subtitle: Text(selectedValue),
      onTap: () {
        // Show a dialog or navigate to a screen for selection
      },
    );
  }

  Widget _buildSliderTile(String title, double value) {
    return ListTile(
      title: Text(title),
      trailing: Slider(
        value: value,
        onChanged: (double newValue) {
          setState(() {
            selectedAlertSoundLevel = newValue;
          });
        },
      ),
    );
  }

  Widget _buildRadioTile(String title, String value, bool selected) {
    return ListTile(
      title: Text(title),
      leading: Radio(
        value: value,
        groupValue: 'language', // Use a unique group value for each group
        onChanged: (String? newValue) {
          setState(() {
            selectedLanguage = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildAboutTile(String title) {
    return ListTile(
      title: Text(title),
      onTap: () {
        setState(() {
          aboutItemClicked = title;
        });
        // Handle about item tap
      },
    );
  }
}
