
import 'dart:async';
import 'dart:convert';

import 'package:erp_project/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/forgotpassword_model.dart';

class ForgotpassController extends GetxController{
  TextEditingController currentController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController confrimController = TextEditingController();

  BuildContext? context;
  ForgotpassController({this.context});


 /* changePasswordApi(BuildContext context,String token) async {
    print("current:" + currentController.text);
    print("new:" + newController.text);
    Map<String, dynamic> map = Map<String, dynamic>();
    print("progressbarshow.....");

    map["email"] = currentController.text.trim();
    map["password"] = newController.text.trim();

    Webservice().loadPostWithToken(getSignIn, map,token).then(
          (model) async => {
        print("data is::" + model.data!.toString()),
        print("message is::" + model.message.toString()),
        pref = await SharedPreferences.getInstance(),
        await pref.setString("login", model.data!.toString()),
        print("progressbars hide0....."),

        if (model.status == "200")
          {
            Get.snackbar("Success", "Login Successfully"),
            if (model.status == "0")
              {
                print('st 0 ${model.status}'),
                currentController.clear(),
                newController.clear(),
              }
            else
              {
                // addBoolToSF(true, model),
                print('st new ${model.status!}'),
                currentController.clear(),
                newController.clear(),
              },
            //     Get.offAll(HomePage())
          }
        else
          {
            print("progressbars hide1....."),
            print(model.message),
            Timer(const Duration(seconds: 1), () async {
              // CustomLoder.hideProgressDialog(context);
              Get.offAll(DashboardScreen());
            }),
            // addBoolToSF(false, model),
          },
        // {storage.write(isLogin, false)}
      },
    );
  }

  Resource<Changepassword> get getSignIn {
    return Resource(
        url: ApiString.changepass,
        parse: (response) {
          var result;

          //     Get.back();
          //      final result = json.decode(response.body);
          if (response.body.isNotEmpty) {
            result = json.decode(response.body);
            print("responce" + response.body.toString());
          } else {
            print("empty responce");
          }
          print("" + ".......getSupplierLogin......." + result.toString());
          String success = result["status"].toString();
          if (success == "200") {
            // loader.value = false;
            *//* String message = result["message"];
            Get.snackbar(
                duration: Duration(milliseconds: 1200),
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                margin: EdgeInsets.only(),
                borderRadius: 0,
                backgroundColor: AppColors.mainColor,
                "Successfully",
                message);*//*
            return changepasswordFromJson(response.body);
          } else {
            // loader.value = false;
            print("progressbar hide2.....");

            String message = result["message"];
            Timer(const Duration(seconds: 1), () async {
              // CustomLoder.hideProgressDialog(context!);
              Get.snackbar(
                  duration: Duration(milliseconds: 1200),
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  margin: EdgeInsets.only(),
                  borderRadius: 0,
                  backgroundColor: Colors.blue,
                  "",
                  message);
            });

            //Get.to(DashboardScreen());
            return changepasswordFromJson(response.body);
          }
        });
  }*/

  changePasswordApi(String token,BuildContext context) async {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["current_password"] = currentController.text.trim();
    map["new_password"] = newController.text.trim();

    print("Token::::::${token}");

    Webservice().loadPostWithToken(getcheckInApi, map, token).then(
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
                currentController.clear(),
                newController.clear()
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
            Timer(const Duration(seconds: 1), () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            }),
          },
        // {storage.write(isLogin, false)}
      },
    );
  }

  Resource<Changepassword> get getcheckInApi {
    return Resource(
        url: ApiString.changepass,
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

            return changepasswordFromJson(response.body);
          } else {
            // loader.value = false;
            String message = result["message"];
            Get.snackbar(
                duration: Duration(milliseconds: 1200),
                snackPosition: SnackPosition.BOTTOM,
                colorText: Colors.white,
                margin: EdgeInsets.only(),
                borderRadius: 0,
                backgroundColor: Color(0xff41069D),
                "",
                message);
            print(message);
            // ScaffoldMessenger.of(context!).showSnackBar(SnackBar(
            //   content: Text(message),
            // ));
            //Get.to(DashboardScreen());
            return changepasswordFromJson(response.body);
          }
        });
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