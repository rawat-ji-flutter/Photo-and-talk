// @dart = 2.9
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ExitAlertDialog {

  Future<bool> showexitpop(context) {
    Size size = MediaQuery.of(context).size;
    Alert(
      image: Column(
        children: [
          Text(
            "Are you sure you want to exit the app?",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.buttonColor),
          ),
        ],
      ),
      context: context,
      style: AlertStyle(titleStyle: TextStyle(color: AppColors.buttonColor)),
      buttons: [
        DialogButton(
          child: Text(
            "EXIT",
            style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
          ),
          onPressed: () => exit(0),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "CANCEL",
            style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          color: AppColors.buttonColor,
        )
      ],
    ).show();
  }
}