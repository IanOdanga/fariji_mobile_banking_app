import 'package:fariji_flutter_mobile_app/Screens/accounts_screen.dart';
import 'package:fariji_flutter_mobile_app/Screens/login_screen.dart';
import 'package:fariji_flutter_mobile_app/Screens/profile_screen.dart';
import 'package:fariji_flutter_mobile_app/Screens/settings_ui.dart';
import 'package:fariji_flutter_mobile_app/Services/shared_preferences_service.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomSidebarDrawer extends StatefulWidget {

  /*final Function drawerClose;

  const CustomSidebarDrawer({Key? key, required this.drawerClose}) : super(key: key);*/

  @override
  _CustomSidebarDrawerState createState() => _CustomSidebarDrawerState();
}

class _CustomSidebarDrawerState extends State<CustomSidebarDrawer> {

  String? memberName;
  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.withAlpha(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/user_icon.png",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(memberName?? '',
                      style: TextStyle(fontFamily: "Brand-Regular"))
                ],
              )),
          ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            leading: const Icon(Icons.person),
            title: const Text(
              "Your Profile",
                style: TextStyle(fontFamily: "Brand Bold")
            ),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Accounts()));
            },
            leading: const Icon(Icons.account_balance),
            title: const Text("My Accounts", style: TextStyle(fontFamily: "Brand Bold")),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
            },
            leading: const Icon(Icons.settings),
            title: const Text("Settings", style: TextStyle(fontFamily: "Brand Bold")),
          ),
          const Divider(
            height: 1,
            color: Colors.grey,
          ),

          ListTile(
            onTap: () {
              final SecureStorage secureStorage = SecureStorage();
              secureStorage.deleteSecureToken('Token');
              secureStorage.deleteSecureToken('telephone');
              secureStorage.deleteSecureToken('tokenTime');
              secureStorage.deleteSecureToken('Password');
              logout();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route route) => false,);
              },
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Log Out", style: TextStyle(fontFamily: "Brand Bold")),
          ),
        ],
      ),
    );
  }
  Future<String>getName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('Name') ?? '';

    setState(() {
      memberName = name;
    });
    return name;
  }
}