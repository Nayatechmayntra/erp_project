import 'dart:async';
import 'dart:convert';
import 'package:erp_project/modal/login_model.dart';
import 'package:erp_project/screen/dashboard_screen.dart';
import 'package:erp_project/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../value/customLoder.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefname;
  late SharedPreferences preflocation;
  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  late StreamSubscription<Position> streamSubscription;
  var address = 'Getting Address..'.obs;
  var isLocation = false.obs;
  var username = '';
  var userLocation = '';
  var loader = false.obs;

  Login login = Login();
  var email = '';
  var pass = '';

  BuildContext? context;
  LoginController({this.context});
  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    emailController.dispose();
    passwordController.dispose();
  }

  void checkLocationPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      var status = await Permission.location.status;
      if (status.isGranted) {
        isLocation.value = true;
        print("Location Permission is Granted");
      } else if (status.isDenied) {
        print("Location Permission is not Granted");
        ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
          content: Text("Location Permission is not Grantee."),
        ));
        openAppSettings();
      }
    } else {
      ScaffoldMessenger.of(context!).showSnackBar(const SnackBar(
        content: Text("Loaction Permission is not enable."),
      ));
    }
  }

  doLoginApi(BuildContext context) async {
    Map<String, dynamic>? map = Map<String, dynamic>();

    map["username"] = emailController.text.toString();
    map["password"] = passwordController.text.toString();
    map["latitude"] = latitude.toString();
    map["longitude"] = longitude.toString();

    Webservice().loadPost(getSignIn, map).then(
          (model) async => {
            print("Status is::" + model.status.toString()),
            pref = await SharedPreferences.getInstance(),
            await pref.setString("login", model.token.toString()),
            prefname = await SharedPreferences.getInstance(),
            await prefname.setString(
                "username", model.data!.employeeData!.name.toString()),
            print("name is::" + model.data!.employeeData!.name.toString()),
            username = model.data!.employeeData!.name.toString(),
            print("token is::" + pref.toString()),
            if (model.status == "200")
              {
                Get.snackbar("Success", "Login Successfully"),
                if (model.status == "0")
                  {
                    email = emailController.text.trim(),
                    pass = passwordController.text.trim()
                  }
                else
                  {emailController.clear(), passwordController.clear()},
              }
            else
              {
                print("message" + model.message.toString()),
                Timer(const Duration(seconds: 1), () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                }),
              },
          },
        );
  }

  Resource<Login> get getSignIn {
    return Resource(
        url: ApiString.login,
        parse: (response) {
          var result;
          print(" responce::::::" + response.body);
          if (response.body.isNotEmpty) {
            result = json.decode(response.body);
            print("responce" + response.body.toString());
          } else {
            print("empty responce");
          }
          print("" + ".......getSupplierLogin......." + result.toString());
          String success = result["status"].toString();
          if (success == "200") {
            loader.value = false;

            return loginFromJson(response.body);
          } else {
            print("progressbar hide2.....");
            loader.value = false;
            Timer(const Duration(milliseconds:000), () async {
              //CustomLoder.hideProgressDialog(context!);
              String message = result["message"];
              print("check message:::::" + message);
              Get.snackbar(
                  duration: Duration(milliseconds: 1200),
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  margin: EdgeInsets.only(),
                  borderRadius: 0,
                  backgroundColor: Color(0xff41069D),
                  "",
                  message);
            });

            //Get.to(LoginScreen());
            return loginFromJson(response.body);
          }
        });
  }

  getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      latitude.value = 'Latitude : ${position.latitude}';
      longitude.value = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    address.value = 'Address : ${place.locality},${place.country}';
    print('Address:::::${address.value}');
  }

  void validationSnackbar(String error, String msg) {
    Get.snackbar(
      error,
      msg,
      duration: Duration(milliseconds: 1200),
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      margin: EdgeInsets.only(),
      borderRadius: 0,
      backgroundColor: Colors.blue,
    );
  }
}
