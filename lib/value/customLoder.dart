import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLoder{
  static bool isShowing = false;
  late BuildContext context;

  static void showProgressDialog(BuildContext context) {
    isShowing = true;
    showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) {
          return Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3,sigmaY: 3),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                height: 90.h,
                width: 90.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Center(
                  child: CupertinoActivityIndicator(color: Colors.blue,radius: 20.0,),
                ),
              ),
            ),
          );
        });
  }

  static void hideProgressDialog(BuildContext context) {
    if (isShowing) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      isShowing = false;
    }
  }
}