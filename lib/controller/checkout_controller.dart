import 'dart:async';
import 'dart:convert';
import 'package:erp_project/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/checkout_model.dart';

class CheckOutController extends GetxController {
  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  late StreamSubscription<Position> streamSubscription;
  var address = 'Getting Address..'.obs;
  Checkout checkout = Checkout();
  List<Data>? checkoutdatalist;
  List<Data>? listdata;
  var ListData = [].obs;
  Checkout? checkoutmodel;
  @override
  void onInit() {
    getLocation();
    super.onInit();
  }

 /* checkOutApi(
    String token,
  ) {
    Map<String, dynamic>? map = Map<String, dynamic>();
    map["latitude"] = latitude.toString();
    map["longitude"] = longitude.toString();

    Webservice().loadPostWithToken(getCheckout, map, token).then(
          (model) => {
            print("name is::" + model.message.toString()),
            if (model.status == "200")
              {
                // Get.snackbar("Success", "Password Change Successfully"),
                print("progressbars hide1....."),
                Timer(const Duration(seconds: 1), () async {
                  Get.offAll(DashboardScreen());
                }),

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
                Timer(const Duration(seconds: 1), () async {}),
                // Get.offAll(LoginScreen()),
              }
          },
        );
  }

  Resource<Checkout> get getCheckout {
    return Resource(
        url: "https://finoel.co.in/public/api/checkout",
        parse: (response) {
          print("Api Url:::::::::${ApiString.checkout}");
          print("Following Response::::::::${response.body}");
          var result;
          if (response.body.isNotEmpty) {
            print("not empty response");
            //checkoutdatalist.addAll(Checkout.fromJson(jsonDecode(response.body)))
            //_popularProductList.addAll(Product.fromJson(jsonDecode(response.body)).products);

            result = json.decode(response.body);
          } else {
            print("empty responce");
          }
          print("" +
              ".......getSupplierLogin from Change Password ......." +
              result.toString());
          String success = response.statusCode.toString();
          if (success == "200") {
            // loader.value = false;
            return checkoutFromJson(response.body);
          } else {
            // loader.value = false;
            String message = result["message"];
            Timer(const Duration(seconds: 1), () async {
              // CustomLoder.hideProgressDialog(context!);
              Get.snackbar(
                  duration: Duration(milliseconds: 1200),
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  margin: EdgeInsets.only(),
                  borderRadius: 0,
                  backgroundColor: Colors.orange,
                  "",
                  message);
            });
            return checkoutFromJson(response.body);
          }
        });
  }*/

  checkOutApi(String token) async {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["latitude"] = latitude.toString();
    map["longitude"] = longitude.toString();

    print("Token::::::${token}");

    Webservice().loadPostWithToken(getcheckOutApi, map, token).then(
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

  Resource<Checkout> get getcheckOutApi {
    return Resource(
        url: ApiString.checkout,
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
            return checkoutFromJson(response.body);
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
            return checkoutFromJson(response.body);
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
