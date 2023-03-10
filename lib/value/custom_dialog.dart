//custom_alert_dialog.dart

import 'package:erp_project/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';


import '../controller/login_controller.dart';
import '../screen/login_screen.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String title, description;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  LoginController loginController = LoginController();

  // void checkLocationPermission()async{
  //   if(await Permission.location.serviceStatus.isEnabled){
  //     var status = await Permission.location.status;
  //     if(status.isGranted){
  //       print("Location Permission is Granted");
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Location Permission is Grantee."),
  //       ));
  //       loginController.doLoginApi(context);
  //     }else if(status.isDenied){
  //       print("Location Permission is not Granted");
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text("Location Permission is not Grantee."),
  //       ));
  //       openAppSettings();
  //     }
  //   }
  //   else{
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Loaction Permission is not enable."),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 150.h,
          width: 289.h,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Text(
                  "${widget.title}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text("${widget.description}",style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                ),),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.black,
                      height: 40,
                      width: 100.0,
                      child: InkWell(
                        highlightColor: Colors.grey[200],
                        onTap: (){
                          loginController.checkLocationPermission();
                        },
                        child: Center(
                          child: Text(
                            "Allow",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      height: 40,
                      width: 100.0,
                      child: InkWell(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15.0),
                          bottomRight: Radius.circular(15.0),
                        ),
                        highlightColor: Colors.grey[200],
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "Decline",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
