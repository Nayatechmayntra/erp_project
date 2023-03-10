import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/forgotpass_controller.dart';
import '../controller/login_controller.dart';
import '../controller/logout_controller.dart';
import 'LeaveListScreen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  ForgotpassController forgotpassController = ForgotpassController();
  LoginController loginController = LoginController();
  LogoutController logoutController = LogoutController();

  SharedPreferences? preferences;
  String? token;
  String? username;

  @override
  void initState() {
    checktoken();
    super.initState();
  }

  checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("login");
    // forgotpassController.changePasswordApi(context,preferences.getString("login")!);

    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: Colors.black,
                ),
                onPressed: () => setState(() {
                      Scaffold.of(context).openDrawer();
                    })),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.transparent,
          child: ListView(
            padding: EdgeInsets.only(top: 80.0),
            children: [
              ListTile(
                title: Text(
                  "Hello ${username}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.white),
                ),
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Image.asset('assets/leaveicon.png'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Leave Applications',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                  ],
                )),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => LeaveListScreen()));
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Image.asset('assets/changepass.png'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Change Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                  ],
                )),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => ForgotPassScreen()));
                },
              ),
              ListTile(
                title: Container(
                    child: Row(
                  children: [
                    Image.asset('assets/logouticon.png'),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text('Logout',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white)),
                  ],
                )),
                onTap: () {
                  showlogoutPopup();

                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      });
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                SizedBox(
                  height: 80.0,
                ),
                Center(
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32.0,
                        color: Colors.black),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextField(
                          obscureText: true,
                          controller: forgotpassController.currentController,
                          maxLength: 100,
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
                              counterText: "",
                              hintText: 'Current Password',
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextField(
                          obscureText: true,
                          controller: forgotpassController.newController,
                          maxLength: 100,
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
                              counterText: "",
                              hintText: 'New Password',
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: TextField(
                            obscureText: true,
                            maxLength: 100,
                            controller: forgotpassController.confrimController,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
                              counterText: "",
                              hintText: 'Confirm Password',
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),

                            ),

                          ),
                        ),
                      ),
                    )),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      validation(context);
                      print("submit clicked...");
                    },
                    child: Container(
                      height: 35.h,
                      width: 90.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
      //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2,
        ));
  }

  void validation(BuildContext context) async {
    if (forgotpassController.currentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Current Password is Required"),
      ));
    } else if (forgotpassController.newController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("New Password is Required"),
      ));
    } else if (forgotpassController.confrimController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Confrim Password is Required"),
      ));
    }
    else if(forgotpassController.newController.text!=forgotpassController.confrimController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password does not match.\nPlease re-type again "),
      ));
    }
    else {
      bool isOnline = await hasNetwork();
      if (isOnline) {
        print("clicked");
        forgotpassController.changePasswordApi(token!, context);
      } else {
        forgotpassController.validationSnackbar(
            "Error", "Internet not available");
      }
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text('No'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41069D),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              exit(0);
            },
            //return true when click on "Yes"
            child: Text('Yes'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41069D),
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
  Future<bool> showlogoutPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout App'),
        content: Text('Do you want to Logout an App?'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child: Text('No'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41069D),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool isOnline = await hasNetwork();
              if (isOnline) {
                SharedPreferences preferences =
                await SharedPreferences.getInstance();
                logoutController.logoutApi(
                    preferences.getString("login")!, context);
                await preferences.remove('login');
              } else {
                Get.snackbar("Error", "Internet not available");
              }
            },
            //return true when click on "Yes"
            child: Text('Yes'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xff41069D),
            ),
          ),
        ],
      ),
    ) ??
        false; //if showDialouge had returned null, then return false
  }
}
