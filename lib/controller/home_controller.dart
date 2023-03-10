import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_string.dart';
import '../Api/network_call.dart';
import '../modal/home_model.dart';

class HomeController extends GetxController {
  RxList<HomeList> homeDatalist = <HomeList>[].obs;
  late Homelistmodel homemodel;
  var loader = false.obs;
  var dashboardlist = [].obs;
  var PT_hours="0".obs;
  var PT_minutes="0".obs;
  var PT_seconds="0".obs;
  @override
  Future<void> onInit() async {
    super.onInit();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    homelistApi(preferences.getString("login").toString());
    
  }

  homelistApi(
    String token,
  ) async {
    homeDatalist.clear();
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

  Resource<Homelistmodel> get getleaveList {
    return Resource(
        url: ApiString.home,
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
            homemodel = Homelistmodel.fromJson(json.decode(response.body));
            homeDatalist.addAll(homemodel.data!);
            dashboardlist.addAll(homemodel.data!);
            print("homelist Response::::::::${homeDatalist}");
            print("productiveTime Response::::::::${homeDatalist[0].productiveTime!.h}");


            return homelistmodelFromJson(response.body);
          } else {
            loader.value = false;
            // hasPages = false;
            String message = result["message"];
            Get.snackbar("Error", message);
            return homelistmodelFromJson(response.body);
          }
        });
  }

// homeApi(
  //     String token,
  //     ) async {
  //   homeDatalist.clear();
  //   loader.value = true;
  //   Webservice().loadGetWithToken(gethomeList, token,).then(
  //         (model) => {
  //       print("home name is::" + model.data.toString()),
  //
  //       if (model.status == "200") {
  //
  //       } else {
  //
  //       }
  //     },
  //   );
  // }
  //
  // Resource<Homemodel> get gethomeList {
  //   return Resource(
  //       url: ApiString.home,
  //       parse: (response) {
  //         //print("Following Api::::::::${"https://api.mimap.website/v1/user/myfollowing/?page=$currentPage"}");
  //
  //         print("home Api::::::::${ApiString.home}");
  //         print("home Response::::::::${response.body}");
  //
  //         var result;
  //         if (response.body.isNotEmpty) {
  //           result = json.decode(response.body);
  //           print("home Response::::::::${response.body}");
  //         } else {
  //           print("empty response");
  //         }
  //         print("" + "..... ..getSupplier......" + result.toString());
  //
  //         String success = response.statusCode.toString();
  //         if (success == "200") {
  //           loader.value = false;
  //           // followerModel = FollowerList.fromJson(json.decode(response.body));
  //           // followerDataList.addAll(followerModel.data!.data!);
  //           homemodel = Homemodel.fromJson(json.decode(response.body));
  //           homeDatalist.addAll();
  //
  //           print("Homedata length"+homeDatalist.length.toString());
  //           return homemodelFromJson(response.body);
  //         } else {
  //           loader.value = false;
  //           // hasPages = false;
  //           String message = result["message"];
  //           Get.snackbar("Error", message);
  //           return homemodelFromJson(response.body);
  //         }
  //       });
  // }

}
