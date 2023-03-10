import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:custom_timer/custom_timer.dart';
import 'package:erp_project/controller/login_controller.dart';
import 'package:erp_project/screen/forgotpass_screen.dart';
import 'package:erp_project/screen/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/breakin_controller.dart';
import '../controller/breakout_controller.dart';
import '../controller/checkin_controller.dart';
import '../controller/checkout_controller.dart';
import '../controller/currentlocation_controller.dart';
import '../controller/getlocation_controller.dart';
import '../controller/home_controller.dart';
import '../controller/logout_controller.dart';
import 'LeaveListScreen.dart';

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  CurrentlocationController currentlocationController =
      CurrentlocationController();
  SendPort? _sendPort;
  int _eventCount = 0;
  String? token;

  Future<void> checkForCurrentLocation() async {
    currentlocationController.getLocation();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("login");
    currentlocationController.currentLocationApi(token ?? "null token");
    Timer mytimer = Timer.periodic(Duration(seconds: 10), (timer) async {});
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;

    // You can use the getData function to get the stored data.
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // FlutterForegroundTask.updateService(
    //   notificationTitle: 'myHRMS',
    //   //notificationText: 'eventCount: $_eventCount',
    // );

    // Send data to the main isolate.
    sendPort?.send(_eventCount);
    checkForCurrentLocation();
    _eventCount++;
    Timer mytimer = Timer.periodic(Duration(seconds: 15), (timer) {
      print("Executed after 15 seconds");
      sendPort?.send(_eventCount);
      checkForCurrentLocation();
      _eventCount++;
    });
    mytimer.cancel();

    // Timer(const Duration(seconds: 15), () async {
    //   sendPort?.send(_eventCount);
    //   checkForCurrentLocation();
    //   _eventCount++;
    // });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    // Called when the notification button on the Android platform is pressed.
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    // Called when the notification itself on the Android platform is pressed.
    //
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // this function to be called.

    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  LogoutController logoutController = LogoutController();
  CheckOutController checkoutController = CheckOutController();
  CheckInController checkInController = CheckInController();
  BreakInController breakInController = BreakInController();
  BreakOutController breakOutController = BreakOutController();
  LoginController loginController = LoginController();
  HomeController homeController = HomeController();
  GetlocationController getlocationController = GetlocationController();
  CurrentlocationController currentlocationController =
      CurrentlocationController();
  var formatter = new DateFormat('hh-mm-ss');

  int levelClock = 18000;
  bool isInTime = true;
  bool isOutTime = false;
  bool isbreakin = true;
  bool isbreakout = false;
  String? token;
  String? username;
  SharedPreferences? preferences;
  String? PT_hours;
  String? PT_minutes;
  String? PT_seconds;

  late CustomTimerController controller = CustomTimerController(
    vsync: this,
    begin: Duration(seconds: 0),
    end: Duration(seconds: 3600),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.seconds,
  );

  late CustomTimerController checkIntimecontroller = CustomTimerController(
      vsync: this,
      begin: Duration(
          hours: int.parse(PT_hours??"0"),
          minutes: int.parse(PT_minutes??"0"),
          seconds: int.parse(PT_seconds??"0")),
      end: Duration(hours: 8),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds);
  late CustomTimerController breakIntimecontroller = CustomTimerController(
      vsync: this,
      begin: Duration(seconds: 0),
      end: Duration(minutes: 60),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds);
  late CustomTimerController totaltimecontroller = CustomTimerController(
      vsync: this,
      begin: Duration(seconds: 0),
      end: Duration(minutes: 60),
      initialState: CustomTimerState.reset,
      interval: CustomTimerInterval.milliseconds);

  ReceivePort? _receivePort;

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
          await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        print('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((message) {
      if (message is int) {
        print('eventCount: $message');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        }
      } else if (message is DateTime) {
        print('timestamp: ${message.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;

  @override
  void initState() {
    checktoken();

    //PT_hours = homeController.homemodel.data![0].productiveTime!.h;
    //PT_minutes = homeController.homeDatalist[0].breakTime!.i.compareTo("0") as String;
    //PT_seconds = homeController.homeDatalist[0].totalTime!.s.compareTo("0") as String;
    _startForegroundTask();
    _initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });

    //currentlocationController.getLocation();

    // checkInController.getLocation();
    // totaltimecontroller.start();
    // checkIntimecontroller.start();

    // setState(() {
    //   isInTime = false;
    //   isOutTime = true;
    //   controller.start();
    // });

    super.initState();
  }

  @override
  dispose() {
    _closeReceivePort();
    _stopForegroundTask();
    checkoutController.dispose(); // you need this
    totaltimecontroller.dispose(); // you need this
    checkIntimecontroller.dispose(); // you need this
    super.dispose();
  }

  checktoken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    token = preferences.getString("login");
    await homeController.homelistApi(token!);

    setState(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      username = pref.getString("username");
    });

    // forgotpassController.changePasswordApi(context,preferences.getString("login")!);
  }

  void checkForNewSharedLists() {
    setState(() async {
      await currentlocationController.currentLocationApi(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(
        Duration(seconds: 15), (Timer t) => "checkForNewSharedLists()");
    return WithForegroundTask(
      child: WillPopScope(
        onWillPop: showExitPopup,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: Color(0xffbf7edc),
          appBar: AppBar(
            backgroundColor: Color(0xffbf7edc),
            leading: Builder(
              builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => setState(() {
                        Scaffold.of(context).openDrawer();
                      })),
            ),
          ),
          body: SingleChildScrollView(
            child: Stack(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  "assets/bgimg.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/login_group.png',
                      height: MediaQuery.of(context).size.height / 2.8,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     RoundedButton(
                    //         text: "Check In",
                    //         color: Colors.green,
                    //         onPressed: () {
                    //           setState(() {
                    //             isInTime = true;
                    //           });
                    //           controller.start();
                    //         }),
                    //     RoundedButton(
                    //       text: "Break",
                    //       color: Colors.blue,
                    //       onPressed: () => controller.pause(),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(children: <Widget>[
                          Center(
                            child: Container(
                                height: 164.0,
                                width: 164.0,
                                child: Image.asset('assets/checkinround.png')),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 18),
                              child: Container(
                                height: 130.0,
                                width: 130.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child:
                                          Image.asset('assets/checkinicon.png'),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        bool isOnline = await hasNetwork();
                                        if (isOnline) {
                                          checkoutController
                                              .checkOutApi(token!);
                                        } else {
                                          Get.snackbar("Error",
                                              "Internet not available");
                                        }
                                        setState(() {
                                          isInTime = true;
                                          isOutTime = false;
                                        });
                                        controller.reset();
                                        checkIntimecontroller.reset();
                                        totaltimecontroller.reset();
                                        breakIntimecontroller.reset();
                                      },
                                      child: Visibility(
                                        visible: isOutTime,
                                        child: Container(
                                          height: 30.h,
                                          width: 100.h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Center(
                                                child: Text(
                                              'Check Out',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        bool isOnline = await hasNetwork();
                                        if (isOnline) {
                                          checkInController.checkInApi(token!);
                                        } else {
                                          Get.snackbar("Error",
                                              "Internet not available");
                                        }
                                        setState(() {
                                          isInTime = false;
                                          isOutTime = true;
                                        });
                                        controller.start();
                                        checkIntimecontroller.start();
                                        totaltimecontroller.start();
                                      },
                                      child: Visibility(
                                        visible: isInTime,
                                        child: Container(
                                          height: 30.h,
                                          width: 100.h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Center(
                                                child: Text(
                                              'Check In',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: isOutTime,
                                      child: Text(
                                        DateFormat('hh:mm a')
                                            .format(DateTime.now()),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                        Stack(children: <Widget>[
                          Center(
                            child: Container(
                                height: 164.0,
                                width: 164.0,
                                child: Image.asset('assets/breakinround.png')),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 18.0, left: 18.0),
                              child: Container(
                                height: 130.0,
                                width: 130.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child:
                                          Image.asset('assets/breakinicon.png'),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        bool isOnline = await hasNetwork();
                                        if (isOnline) {
                                          breakInController.breakInApi(token!);
                                        } else {
                                          Get.snackbar("Error",
                                              "Internet not available");
                                        }
                                        setState(() {
                                          isbreakin = false;
                                          isbreakout = true;
                                        });
                                        // breakcontroller.start();
                                        breakIntimecontroller.start();
                                        checkIntimecontroller.pause();
                                      },
                                      child: Visibility(
                                        visible: isbreakin,
                                        child: Container(
                                          height: 30.h,
                                          width: 100.h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Center(
                                                child: Text(
                                              'Break In',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        bool isOnline = await hasNetwork();
                                        if (isOnline) {
                                          breakOutController
                                              .breakOutApi(token!);
                                        } else {
                                          Get.snackbar("Error",
                                              "Internet not available");
                                        }
                                        setState(() {
                                          isbreakout = false;
                                          isbreakin = true;
                                        });
                                        // breakcontroller.pause();
                                        breakIntimecontroller.pause();
                                        checkIntimecontroller.start();
                                      },
                                      child: Visibility(
                                        visible: isbreakout,
                                        child: Container(
                                          height: 35.h,
                                          width: 100.h,
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Center(
                                                child: Text(
                                              'Break Out',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Text(
                                    //   DateFormat('hh:mm a').format(DateTime.now()),
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 20,
                                    //       color: Colors.black),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 30.0,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "TODAY LOGIN",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                                height: 30.0,
                                width: 30.0,
                                color: Colors.white,
                                child: Image.asset(
                                  'assets/rightarrow.png',
                                  height: 28.0,
                                  width: 28.0,
                                )),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 40.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Checkin Time'),
                                  CustomTimer(
                                      controller: checkIntimecontroller,
                                      builder: (state, remaining) {
                                        // Build the widget you want!
                                        return Column(
                                          children: [
                                            Text(
                                                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                style:
                                                    TextStyle(fontSize: 18.0)),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                                height: 30.0,
                                width: 30.0,
                                color: Colors.white,
                                child: Image.asset(
                                  'assets/rightarrow.png',
                                  height: 28.0,
                                  width: 28.0,
                                )),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 40.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Breakin Time'),
                                  CustomTimer(
                                      controller: breakIntimecontroller,
                                      builder: (state, remaining) {
                                        // Build the widget you want!
                                        return Column(
                                          children: [
                                            Text(
                                                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                style:
                                                    TextStyle(fontSize: 18.0))
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                                height: 30.0,
                                width: 30.0,
                                color: Colors.white,
                                child: Image.asset(
                                  'assets/rightarrow.png',
                                  height: 28.0,
                                  width: 28.0,
                                )),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Container(
                            height: 40.0,
                            width: MediaQuery.of(context).size.width / 1.3,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Time'),
                                  CustomTimer(
                                      controller: totaltimecontroller,
                                      builder: (state, remaining) {
                                        // Build the widget you want!
                                        return Column(
                                          children: [
                                            Text(
                                                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                                                style:
                                                    TextStyle(fontSize: 18.0))
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )

                    // InkWell(
                    //   onTap: () async {
                    //     bool isOnline = await hasNetwork();
                    //     if (isOnline) {
                    //       checkInController.checkInApi(token!);
                    //     } else {
                    //       Get.snackbar("Error", "Internet not available");
                    //     }
                    //     setState(() {
                    //       isInTime = false;
                    //       isOutTime = true;
                    //     });
                    //     controller.start();
                    //   },
                    //   child: Visibility(
                    //     visible: isInTime,
                    //     child: Container(
                    //       height: 35.h,
                    //       width: 100.h,
                    //       color: Colors.black,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(0.0),
                    //         child: Center(
                    //             child: Text(
                    //               'CheckIn',
                    //               style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 22.0,
                    //                   fontWeight: FontWeight.bold),
                    //             )),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10.0,
                    // ),
                    // Visibility(
                    //   visible: isOutTime,
                    //   child: Text(
                    //     DateFormat('hh:mm a').format(DateTime.now()),
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 22,
                    //         color: Colors.white),
                    //   ),
                    // ),
                    // CustomTimer(
                    //     controller: controller,
                    //     builder: (state, remaining) {
                    //       // Build the widget you want!
                    //       return Column(
                    //         children: [
                    //           Text(
                    //               "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                    //               style: TextStyle(
                    //                   fontSize: 24.0, color: Colors.white))
                    //         ],
                    //       );
                    //     }),
                    // SizedBox(height: 24.0),
                    // SizedBox(height: 12.0),
                  ],
                ),
              ),
            ]),
          ),
          drawer: Drawer(
            backgroundColor: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.only(top: 80.0),
              children: [
                ListTile(
                  title: Text(
                    "Hello ${username.toString()}",
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
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text('Driving Route',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white)),
                    ],
                  )),
                  onTap: () async {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => MapView(
                              lat: checkInController.latitude.toString(),
                              long: checkInController.longitude.toString(),
                            )));
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
                  onTap: () async {
                    showlogoutPopup();
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (BuildContext context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
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
