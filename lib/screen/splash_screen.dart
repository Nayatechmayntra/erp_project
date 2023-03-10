import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/svg.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences pref;

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () async {
       checkLogin(context!);
    });

    super.initState();
  }

  void checkLogin(BuildContext ctx) async {
    pref = await SharedPreferences.getInstance();
    var val = pref.getString("login");
    if (val == null) {
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (context) => LoginScreen ()),
      );
    } else {
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child:
                  Image.asset(
                    "assets/bgimg.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  child: Center(
                    child: Image.asset(
                      "assets/applogo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            )

            // Container(
            //   child: Center(child: Image.asset("assets/bgimg.jpg",fit: BoxFit.cover,),
            //   ),
            // ),
            ));
  }
}
