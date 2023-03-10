import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/breakin_model.dart';

class BreakOutController extends GetxController {
  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  late StreamSubscription<Position> streamSubscription;
  var address = 'Getting Address..'.obs;

  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

  breakOutApi(String token) async {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["latitude"] = latitude.toString();
    map["longitude"] = longitude.toString();

    print("Token::::::${token}");

    Webservice().loadPostWithToken(getbreakOutApi, map, token).then(
          (model) => {
            print("Token::::::${token}"),
            // print("name is::" + model.data!.username.toString()),
            // CustomLoder.hideProgressDialog(context),
            // CustomLoder.hideProgressDialog(context),
            if (model.status == "200")
              {
                if (model.status == "0")
                  {
                    print('st 0 ${model.status}'),
                  }
                else
                  {
                    // addBoolToSF(true, model),
                    print('st new ${model.status}'),
                  },
                //     Get.offAll(HomePage())
              }
            else
              {
                // print(model.data!.username),
                // Get.offAll(LoginScreen()),
                // addBoolToSF(false, model),
              },
            // {storage.write(isLogin, false)}
          },
        );
  }

  Resource<Breakin> get getbreakOutApi {
    return Resource(
        url: ApiString.breakout,
        parse: (response) {
          var result;
          if (response.body.isNotEmpty) {
            result = json.decode(response.body);
          } else {
            print("empty responce");
          }
          print("" + ".......getSupplierLogin......." + result.toString());
          String success = result["status"].toString();
          if (success == "200") {
            // loader.value = false;
            /* String message = result["message"];
            Get.snackbar(
                duration: Duration(milliseconds: 1200),
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                margin: EdgeInsets.only(),
                borderRadius: 0,
                backgroundColor: AppColors.mainColor,
                "Successfully",
                message);*/
            return breakinFromJson(response.body);
          } else {
            // loader.value = false;
            String message = result["message"];
            Get.snackbar(
                duration: Duration(milliseconds: 1200),
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                margin: EdgeInsets.only(),
                borderRadius: 0,
                backgroundColor: Colors.blue,
                "",
                message);
            //Get.to(DashboardScreen());
            return breakinFromJson(response.body);
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
}
