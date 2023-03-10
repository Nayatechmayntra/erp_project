import 'dart:async';
import 'dart:convert';

import 'package:erp_project/screen/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/logout_model.dart';

class LogoutController extends GetxController {
SharedPreferences? preferences;

  logoutApi(String token,BuildContext context, {isRefresh = false}) async {
    Webservice().loadGetWithToken(getlogout, token).then(
          (model)  async => {
            print("feed name is::" + model.message.toString()),
            if (model.status == "200") {


            } else {
              print("message"+model.message.toString()),
              preferences  = await SharedPreferences.getInstance(),
              await preferences!.remove('login'),
              Timer(const Duration(seconds: 1), () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }),

            }
          },
        );
  }

  Resource<Logout> get getlogout {
    return Resource(
        url: ApiString.logout,
        parse: (response) {
          print("Following Api::::::::${ApiString.logout}");
          print("Following Response::::::::${response.body}");

          var result;
          if (response.body.isNotEmpty) {
            result = json.decode(response.body);
            print("Following Response::::::::${response.body}");
          } else {
            print("empty response");
          }
          print("" + ".......getSupplier......" + result.toString());

          String success = response.statusCode.toString();
          if (success == "200") {

            return logoutFromJson(response.body);
          } else {
            String message = result["message"];
            Get.snackbar("Error", message);
            return logoutFromJson(response.body);
          }
        });
  }
}
