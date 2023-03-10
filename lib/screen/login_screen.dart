import 'dart:io';

import 'package:erp_project/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../value/customLoder.dart';


class LoginScreen extends GetView<LoginController>  {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
  RegExp emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
  LoginController loginController = LoginController();


  @override
  Widget build(BuildContext context) {
    Get.put(LoginController(context:context));

    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
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
                children: [
                  Image.asset(
                    'assets/login_group.png',
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        maxLength: 200,
                        maxLines: 1,
                        controller: loginController.emailController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
                          counterText: "",
                          labelText: 'Email',
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: 40.h,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        obscureText: true,
                        controller: loginController.passwordController,
                        style: TextStyle(color: Colors.white),
                        maxLength: 100,
                        maxLines: 1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(30.0)),
                          counterText: "",
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(color: Colors.white),
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: myinputborder(),
                          focusedBorder: myfocusborder(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: () {
                      validation(context);
                      print("submit clicked...");
                    },
                    child: Container(
                      height: 35.h,
                      width: 90.h,
                      decoration: BoxDecoration(
                        color: Color(0xff41069D),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
                ],
              ),
            ),

          ]),


      ),
    ));
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
    if (loginController.emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email is Require"),
      ));
    } else if (!emailValid.hasMatch(loginController.emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Enter Valid Email."),
      ));
    } else if (loginController.passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password is Required."),
      ));
    } else {
      // nextScreen(context,  DashboardScreen());
      bool isOnline = await hasNetwork();
      if (isOnline) {
        loginController.doLoginApi(context);

        // if (loginController.isLocation.value == true) {
        //   loginController.doLoginApi(context);
        // }
        // else if (loginController.isLocation.value == false) {
        //   showDialog(
        //     barrierColor: Colors.black26,
        //     context: context,
        //     builder: (context) {
        //       return CustomAlertDialog(
        //         title: "Allow Location Sharing",
        //         description:
        //             "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has beenthe industry's standard dummy",
        //       );
        //     },
        //   );
        // }

        // controller.loader.value = true;
      } else {
        loginController.validationSnackbar("Error", "Internet not available");
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
}
