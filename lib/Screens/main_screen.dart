import 'dart:convert';
import 'package:fariji_flutter_mobile_app/Drawer/custom_sidebar_drawer.dart';
import 'package:fariji_flutter_mobile_app/Model/accounts_model.dart';
import 'package:fariji_flutter_mobile_app/Screens/cash_withdrawals_screen.dart';
import 'package:fariji_flutter_mobile_app/Screens/profile_screen.dart';
import 'package:fariji_flutter_mobile_app/Screens/settings_ui.dart';
import 'package:fariji_flutter_mobile_app/Screens/statements.dart';
import 'package:fariji_flutter_mobile_app/Screens/terms_screen.dart';
import 'package:fariji_flutter_mobile_app/Services/check_validity.dart';
import 'package:fariji_flutter_mobile_app/Services/shared_preferences_service.dart';
import 'package:fariji_flutter_mobile_app/Services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Deposits/deposits_screen.dart';
import 'Funds Transfer/funds_transfer_screen.dart';
import 'accounts_screen.dart';
import 'airtime_screen.dart';
import 'legal_screen.dart';
import 'Loans/loans_screen.dart';
import 'login_screen.dart';

const Color backgroundColor = Color(0xFF2d2d39);

class TransactionDetails {
  final String item;
  final String companyName;
  final int ammount;
  final bool income;
  final IconData icon;

  TransactionDetails({
    required this.item,
    required this.ammount,
    required this.companyName,
    required this.income,
    required this.icon,
  });
}

class MenuDashboardPage extends StatefulWidget {
  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 200);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  double mainBorderRadius = 0;
  Brightness statusIconColor = Brightness.dark;

  //FSBStatus? _fsbStatus;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(_controller);
    _menuScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? memberName;
  double? accBalance;
  String? accNumber;
  @override
  void init() {
    super.initState();
    getMemberInfo();
  }

  AccountsResponseModel? accountModel;

  @override
  void initS() {
    super.initState();
    getMemberInfo();
    accountModel = AccountsResponseModel.fromJson(getMemberInfo());
  }

  Widget menuItem({
    required IconData iconData,
    required String title,
    bool active: false,
  }) {
    return SizedBox(
      width: 0.5 * screenWidth,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Icon(
                iconData,
                color: (active) ? Colors.white : Colors.grey,
                size: 22,
              ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  title,
                  style: TextStyle(
                    color: (active) ? Colors.white : Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    if (checkValidity() == true) {
      final SecureStorage secureStorage = SecureStorage();
      secureStorage.deleteSecureToken('Token');
      secureStorage.deleteSecureToken('Telephone');
      secureStorage.deleteSecureToken('Password');
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    }
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 40),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        width: 0.3 * screenWidth,
                        margin: const EdgeInsets.only(
                          top: 50,
                          bottom: 10,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: <Widget>[
                            SizedBox(
                              height: 0.3 * screenWidth,
                              width: 0.3 * screenWidth,
                              child: Container(
                                alignment: Alignment.topLeft,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/user_icon.png')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListView(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          children: const <Widget>[
                            Text(
                              'Ian Odanga',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        },
                        child: menuItem(
                          title: "Profile",
                          iconData: Icons.account_circle,
                          active: true,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                        },
                        child: menuItem(
                          title: "Settings",
                          iconData: Icons.settings,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                        },
                        child: menuItem(
                          title: "Service Requests",
                          iconData: Icons.receipt,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Legal()));
                        },
                        child: menuItem(
                          title: "Legal",
                          iconData: FontAwesomeIcons.readme,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TermsandConditions()));
                        },
                        child: menuItem(
                          title: "Terms & Conditions",
                          iconData: Icons.developer_board,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: menuItem(
                    title: "Logout",
                    iconData: Icons.exit_to_app,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget creditCard({
    required double amount,
    required String cardNumber,
    required String name,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: MediaQuery.of(context).size.width - 30,
      child: Stack(
        children: <Widget>[
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            children: <Widget>[
              const Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                '\$Ksh. amount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 25,
            bottom: 25,
            child: Container(
              child: const Icon(
                Icons.credit_card,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget transactionList(
      List<TransactionDetails> transactionList,
      String strDate, {
        bool lastElement: false,
      }) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          child: Text(
            strDate,
            style: const TextStyle(
              color: Color(0xffadb2be),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.fromLTRB(5, 10, 5, (lastElement) ? 40 : 5),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            TransactionDetails _transaction = transactionList[index];
            return Container(
              margin: const EdgeInsets.only(
                bottom: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3,
                  )
                ],
              ),
              // padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _transaction.icon,
                    ),
                  ],
                ),
                title: Text(
                  _transaction.item,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  _transaction.companyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  (_transaction.income)
                      ? "+${_transaction.ammount} \$"
                      : " -${_transaction.ammount} \$",
                  style: TextStyle(
                    fontSize: 18,
                    color: (_transaction.income) ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
          itemCount: transactionList.length,
        ),
      ],
    );
  }

  Widget dashboard(context) {
    getMemberInfo();
    if (checkValidity() == true) {
      final SecureStorage secureStorage = SecureStorage();
      secureStorage.deleteSecureToken('Token');
      secureStorage.deleteSecureToken('Telephone');
      secureStorage.deleteSecureToken('Password');
      Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    }
    return Scaffold(
      body: Container(
        //future: getMemberInfo(),
          /*builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                print(snapshot.data);
                Map<String, dynamic> map = json.decode(snapshot.data);
                final data = map;*/

                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: duration,
                      top: 0,
                      bottom: 0,
                      left: isCollapsed ? 0 : 0.5 * screenWidth,
                      width: screenWidth,
                      /*child: ScaleTransition(
                        scale: _scaleAnimation,*/
                        child: Material(
                          borderRadius: BorderRadius.circular(mainBorderRadius),
                          animationDuration: duration,
                          color: const Color(0xfff4faff),
                          child: SafeArea(
                              child: Stack(
                                children: <Widget>[
                                  ListView(
                                    padding: const EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 50,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: Colors.white70,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  /*IconButton(
                                                icon: const Icon(
                                                  Icons.drag_handle,
                                                  color: Colors.black87,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (isCollapsed) {
                                                      mainBorderRadius = 30;
                                                      statusIconColor = Brightness.light;
                                                      _controller.forward();
                                                    } else {
                                                      _controller.reverse();
                                                      mainBorderRadius = 0;
                                                      statusIconColor = Brightness.dark;
                                                    }
                                                    isCollapsed = !isCollapsed;
                                                  });
                                                },
                                              ),*/
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              'assets/images/farijilogo.png'),
                                                        )
                                                    ),
                                                  ),
                                                  /*const Text(
                                                    "Fariji Sacco",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black87,
                                                      fontFamily: "Brand Bold",
                                                    ),
                                                  ),*/
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle_outline,
                                                      color: Color(0xff1c7bfd),
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Container(
                                              height: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width - 30) *
                                                  (8 / 16),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      20),
                                                  bottomRight: Radius.circular(
                                                      20),
                                                ),
                                              ),
                                              child: PageView(
                                                controller: PageController(
                                                    viewportFraction: 0.9),
                                                scrollDirection: Axis
                                                    .horizontal,
                                                pageSnapping: true,
                                                children: <Widget>[
                                                  creditCard(
                                                    amount: accBalance ?? 0,
                                                    name: memberName ?? '',//accountModel!.name.toString(),
                                                    cardNumber: accNumber ?? '',//accountModel!.accountNumber.toString(),
                                                    backgroundColor: Colors
                                                        .deepOrangeAccent,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              padding: const EdgeInsets.all(13),
                                              height: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width) *
                                                  (8 / 10),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: const [
                                                      Text('Services',
                                                        style: TextStyle(
                                                            fontSize: 21,
                                                            fontFamily: 'Brand Bold'
                                                        ),
                                                        textAlign: TextAlign
                                                            .center,
                                                      ),
                                                    ],
                                                  ),

                                                  Expanded(
                                                    child: GridView.count(
                                                      crossAxisCount: 4,
                                                      childAspectRatio: 0.7,
                                                      children: [
                                                        serviceWidgetFunds(
                                                            "sendMoney",
                                                            "Funds\nTransfer"),
                                                        serviceWidgetDeposits(
                                                            "receiveMoney",
                                                            "Cash\nDeposits"),
                                                        serviceWidgetWithdraw(
                                                            "phone",
                                                            "Withdraw\nCash"),
                                                        serviceWidgetUtility(
                                                            "electricity",
                                                            "Utility\nPayments"),
                                                        serviceWidgetAirtime(
                                                            "tag",
                                                            "Purchase\nAirtime"),
                                                        serviceWidgetMini(
                                                            "statements",
                                                            "Mini\nStatements"),
                                                        serviceWidgetLoans(
                                                            "loans", "Loans"),
                                                        serviceWidgetMore(
                                                            "more", "More\n"),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      //),
                    ),
                  ],
                )
              //}
            /*else if (snapshot.hasError) {
              Fluttertoast.showToast(msg: "COULD NOT LOAD DATA!");
              }
            else {
              return const Center(child: CircularProgressIndicator());
              }
            return const SizedBox();
            }*/
      ),
    );
  }

  Widget services (context) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Services', style: TextStyle(
                  fontSize: 21,
                  fontFamily: 'Brand Bold'
              ),),
            ],
          ),

          Expanded(
            child:GridView.count(crossAxisCount: 4,
              childAspectRatio: 0.7,
              children: [
                serviceWidgetFunds("sendMoney", "Funds\nTransfer"),
                serviceWidgetDeposits("receiveMoney", "Cash\nDeposits"),
                serviceWidgetWithdraw("phone", "Withdraw\nCash"),
                serviceWidgetUtility("electricity", "Utility\nPayments"),
                serviceWidgetAirtime("tag", "Purchase\nAirtime"),
                serviceWidgetMini("statements", "Mini\nStatements"),
                serviceWidgetLoans("loans", "Loans"),
                serviceWidgetMore("more", "More\n"),
                ],
              ),
            ),
        ],
      ),
    );
  }
  Column serviceWidgetFunds(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => FundsTransfer()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetDeposits(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: const Duration(seconds: 1), child: DepositsPage()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetWithdraw(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: const Duration(seconds: 1), child: CashWithdrawals()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetUtility(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              //Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: Duration(seconds: 1), child: FundsTransfer()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetAirtime(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: const Duration(seconds: 1), child: Airtime()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetMini(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: const Duration(seconds: 1), child: StatementsPage()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/$img.png'),
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetLoans(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: const Duration(seconds: 1), child: LoansPage()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }

  Column serviceWidgetMore(String img, String name) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              //Navigator.push(context, PageTransition(type: PageTransitionType.rotate,alignment: Alignment.bottomCenter, duration: Duration(seconds: 1), child: FundsTransfer()));
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Color(0xfff1f3f6),
              ),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/$img.png')
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5,),
        Text(name, style: const TextStyle(
          fontFamily: 'Brand-Regular',
          fontSize: 14,
        ),textAlign: TextAlign.center,)
      ],
    );
  }
  @override
  void iniState() {
    var check = checkValidity();
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    getMemberInfo();
    if (checkValidity() == true) {
    final SecureStorage secureStorage = SecureStorage();
    secureStorage.deleteSecureToken('Token');
    secureStorage.deleteSecureToken('Telephone');
    secureStorage.deleteSecureToken('Password');
    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);
    }

    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: statusIconColor,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fariji Sacco",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontFamily: "Brand Bold",
          ),
        ),
          centerTitle: true,
          /*actions: [
            Container(
              //width: 30,
              child: Image.asset(
                'assets/images/farijilogo.png',
              ),
            ),
            //Icon(Icons.more_vert),
          ],*/
          backgroundColor: Colors.white),
        backgroundColor: const Color(0xff343442),
        body: Container(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    //menu(context),
                    dashboard(context),
                  ],
                ),
              ),
        ),
        /*floatingActionButton: FloatingActionButton(
            backgroundColor:Colors.red[400],
            splashColor: Colors.purple,
            child: const Icon(Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if (isCollapsed) {
                  mainBorderRadius = 30;
                  statusIconColor = Brightness.light;
                  _controller.forward();
                } else {
                  _controller.reverse();
                  mainBorderRadius = 0;
                  statusIconColor = Brightness.dark;
                }
                isCollapsed = !isCollapsed;
              });
              //menu(context);
              //AdvancedDrawer;
              *//*setState(() {
                _fsbStatus = _fsbStatus == FSBStatus.FSB_OPEN ?
                FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
              });*//*
            }),*/
      drawer: CustomSidebarDrawer(),
    );
  }
  getMemberInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('Token') ?? '';
    final mobileNo = prefs.getString('telephone') ?? '';

    Map data = {
      "mobile_no": mobileNo
    };
    //print(data);
    final  response= await http.post(
      Uri.parse("https://suresms.co.ke:4242/mobileapi/api/GetmemberInfo"),
      headers: {
        "Accept": "application/json",
        "Token": token
      },
      body: json.encode(data),
    );
    final resp = jsonDecode(response.body);
    //print(response.body);
    if (response.statusCode == 200) {
      //print(response.body);

      Map<String,dynamic>res=jsonDecode(response.body);
      //print(res['Name']);
      prefs.setString('Name', res['Name']);
      prefs.setString('AccNo', res['AccountNumber']);
      prefs.setString('Account_Type', res['Account_Type']);
      prefs.setDouble('Account_Balance', res['Account_Balance']);

      setState(() {
        memberName = res['Name'];
        accBalance = res['Account_Balance'];
        accNumber = res['AccountNumber'];
      });

      final resp = json.decode(response.body);
      accountModel = AccountsResponseModel.fromJson(resp);
      print(accountModel!.memberNo);
      return AccountsResponseModel.fromJson(resp);

    } else if (response.statusCode == 401) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    else {
      Map<String,dynamic>res=jsonDecode(response.body);
      Fluttertoast.showToast(msg: "${res['Description']}");
    }
    return response.body;
  }
}