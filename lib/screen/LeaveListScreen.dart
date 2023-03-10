import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/leaveapply_controller.dart';
import '../controller/logout_controller.dart';
import '../modal/leavelist_model.dart';
import 'forgotpass_screen.dart';
import 'leaveapply_screen.dart';
import 'login_screen.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({Key? key}) : super(key: key);

  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  String? username;
  LeaveApplyController leaveApplyController = LeaveApplyController();
  LogoutController logoutController = LogoutController();

  String? token;
  var formatter = new DateFormat('yyyy-MM-dd');
  List<Datum> dataleavelist = [];

  @override
  void initState() {
    checktoken();

    super.initState();
  }

  checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("login");
    leaveApplyController.leavelistApi(token!);
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString("username");
    print("datasize:::${leaveApplyController.LeaveDataList}");

    // forgotpassController.changePasswordApi(context,preferences.getString("login")!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
          child: Scaffold(
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()));
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Obx(
              () => leaveApplyController.LeaveDataList.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.black, width: 2.0)),
                      child: SingleChildScrollView(
                        child: DataTable(
                            headingRowColor: MaterialStateProperty.all(
                                Colors.deepPurple[200]),
                            columnSpacing: 100,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            columns: [
                              DataColumn(label: Text('Start Date')),
                              DataColumn(label: Text('End Date')),
                              DataColumn(label: Text('Leave Type')),
                              DataColumn(label: Text('Day Type')),
                              DataColumn(
                                  label: Text('                      Reason')),
                              DataColumn(label: Text('Status')),
                            ],
                            rows: [
                              ...leaveApplyController.LeaveDataList.map(
                                  (team) => DataRow(
                                        cells: [
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                formatter
                                                    .format(team.startDate),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ))),
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                formatter.format(team.endDate),
                                              ))),
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(team.leaveType))),
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(team.dayType))),
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(team.reason))),
                                          DataCell(Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(
                                                  team.status.toString()))),
                                        ],
                                      ))
                            ]),
                      ),
                    )
                  : leaveApplyController.loader.value
                      ? Center(
                          child: Container(
                              height: 250.0,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                  radius: 25,
                                ),
                              )))
                      : Center(
                          child: Container(
                          height: 100.0,
                          alignment: Alignment.center,
                          child: Text('Data Loading...',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        )),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LeaveApplicationScreen()));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
          backgroundColor: Color(0xff41069d), //<-- SEE HERE
        ),
      )),
    );
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

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
