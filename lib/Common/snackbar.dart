import 'package:flutter/material.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class Common {
  Future showCommonSnackbar({msg, context}) async {
    final snackBar = SnackBar(
      dismissDirection: DismissDirection.startToEnd,
      content: Text(msg),
      duration: Duration(seconds: 2),
      backgroundColor: AppColors.buttonColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
