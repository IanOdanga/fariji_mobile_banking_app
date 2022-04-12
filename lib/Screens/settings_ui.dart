import 'package:fariji_flutter_mobile_app/Services/check_validity.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'login_screen.dart';

class Settings extends StatefulWidget{
  static const String idScreen = "settings";
  SettingsState createState()=> SettingsState();
}
class SettingsState extends State<Settings> {
  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    if (checkValidity() == true) {
      final SecureStorage secureStorage = SecureStorage();
      secureStorage.deleteSecureToken('Token');
      secureStorage.deleteSecureToken('Telephone');
      secureStorage.deleteSecureToken('Password');
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text('Settings',
              style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brand Bold"
                  )
              ),
          backgroundColor: const Color(0xFF1cb1df),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            titlePadding: const EdgeInsets.all(20),
            title: 'Theme and Language',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                subtitleMaxLines: 4,
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'Use System Theme',
                leading: const Icon(Icons.phone_android),
                switchValue: isSwitched,
                onToggle: (value) {
                  setState(({ switchValue: true}) {
                    isSwitched = value;
                    //EasyDynamicTheme.of(context).changeTheme(dynamic: value);
                  });
                },
              ),
            ],
          ),
          SettingsSection(
            titlePadding: const EdgeInsets.all(20),
            title: 'Section 2',
            tiles: [
              SettingsTile(
                title: 'Security',
                subtitle: 'Fingerprint',
                leading: const Icon(Icons.lock),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: const Icon(Icons.fingerprint),
                switchValue: true,
                onToggle: (value) {
                  setState(() {
                    isSwitched = true;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}