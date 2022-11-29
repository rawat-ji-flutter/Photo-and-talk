import 'package:flutter/material.dart';
import 'dart:io' show Platform, SocketException;

import 'package:photo_talk/Widgets/app_colors.dart';

class CommonButton extends StatelessWidget {
  final double h;
  final double w;
  var title;
  final VoidCallback buttonMethod;
  final double borderRad;
  final bool loading;

  CommonButton(
      {super.key,
        required this.borderRad,
        required this.buttonMethod,
        required this.h,
        required this.w,
        required this.title,
        required this.loading});

  @override
  Widget build(BuildContext context) {
    return
      IgnorePointer(
        ignoring: loading,
        child: ElevatedButton(
            onPressed: buttonMethod,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
                maximumSize: Size(w, h),
                minimumSize: Size(w, h),
                elevation: 8,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRad))),
            child:
            Wrap(
                children: <Widget>[
                  loading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        softWrap: true,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ]) ),
      );
  }
}
