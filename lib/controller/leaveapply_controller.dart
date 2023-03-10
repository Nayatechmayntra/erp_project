import 'dart:async';
import 'dart:convert';

import 'package:erp_project/modal/takeleave_model.dart';
import 'package:erp_project/screen/LeaveListScreen.dart';
import 'package:erp_project/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/leavelist_model.dart';

class LeaveApplyController extends GetxController {
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  String? chosenValue;
  String radioButtonItem = 'Full Day';
  int radioButtonid = 1;
  int leavetype = 2;
  int daytype = 2;
  var LeaveDataList = [].obs;
  late Leavelist leavelist;
  var loader = false.obs;

  BuildContext? context;
  LeaveApplyController({this.context});

  @override
  void initState() {}
  takeleaveApi(String token, BuildContext context) async {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["leave_type"] = int.parse(chosenValue! != "Casual Leave"
            ? 1.toString()
            : chosenValue != "Leave Without Pay"
                ? 0.toString()
                : "")
        .toString();
    map["day_type"] = int.parse(radioButtonItem != "Full Day"
            ? 1.toString()
            : radioButtonItem != "Half Day"
                ? 0.toString()
                : "")
        .toString();
    map["start_date"] = startdateController.text;
    map["end_date"] = enddateController.text;
    map["reason"] = reasonController.text;

    print("Token::::::${token}");
    print("startdate:" + startdateController.text);
    print("enddate:" + enddateController.text);
    print("reason:" + reasonController.text);
    print(
        "leave_type: ${chosenValue! != "Casual Leave" ? 0.toString() : chosenValue != "Leave Without Pay" ? 1.toString() : ""}");
    print(
        "day_type: ${radioButtonItem != "Full Day" ? 0.toString() : radioButtonItem != "Half Day" ? 1.toString() : ""}");

    Webservice().loadPostWithToken(gettakeleaveApi, map, token).then(
          (model) => {
            print("Token::::::${token}"),
            // print("name is::" + model.data!.username.toString()),
            // CustomLoder.hideProgressDialog(context),
            // CustomLoder.hideProgressDialog(context),
            if (model.status == "200")
              {
                if (model.status == "0")
                  {
                    print('click::::::::::::1'),
                    startdateController.clear(),
                    enddateController.clear(),
                    reasonController.clear(),
                  }
                else
                  {
                    print('click::::::::::::2'),
                    startdateController.clear(),
                    enddateController.clear(),
                    reasonController.clear(),
                  },
              }
            else
              {
                print('click::::::::::::'),
                Timer(const Duration(seconds: 1), () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LeaveListScreen()),
                  );
                }),
              },
            // {storage.write(isLogin, false)}
          },
        );
  }

  Resource<Takeleave> get gettakeleaveApi {
    return Resource(
        url: ApiString.takeleave,
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
            return takeleaveFromJson(response.body);
          } else {
            // loader.value = false;
            Timer(const Duration(milliseconds:1000), () async {
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
            return takeleaveFromJson(response.body);
          }
        });
  }

  leavelistApi(
    String token,
  ) async {
    LeaveDataList.clear();
    loader.value = true;
    Webservice()
        .loadGetWithToken(
          getleaveList,
          token,
        )
        .then(
          (model) => {
            print("following name is::" + model.data.toString()),
            if (model.status == "200") {} else {}
          },
        );
  }

  Resource<Leavelist> get getleaveList {
    return Resource(
        url: ApiString.leaveList,
        parse: (response) {
          //print("Following Api::::::::${"https://api.mimap.website/v1/user/myfollowing/?page=$currentPage"}");

          print("Following Api::::::::${ApiString.leaveList}");
          print("Following Response::::::::${response.body}");

          var result;
          if (response.body.isNotEmpty) {
            result = json.decode(response.body);
            print("Following Response::::::::${response.body}");
          } else {
            print("empty response");
          }
          print("" + "..... ..getSupplier......" + result.toString());

          String success = response.statusCode.toString();
          if (success == "200") {
            loader.value = false;

            leavelist = Leavelist.fromJson(json.decode(response.body));
            LeaveDataList.addAll(leavelist.data!);

            return leavelistFromJson(response.body);
          } else {
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

            return leavelistFromJson(response.body);
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
