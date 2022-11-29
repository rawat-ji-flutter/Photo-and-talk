import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class NewProject1 extends StatefulWidget {
  const NewProject1({Key? key}) : super(key: key);

  @override
  State<NewProject1> createState() => _NewProject1State();
}

class _NewProject1State extends State<NewProject1> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Platform.isAndroid
                        ? Icons.arrow_back
                        : Icons.arrow_back_ios),
                  ),
                  Text("New Project", style: mainBoldHeading())
                ],
              ),
              Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.camera_outlined,
                    color: AppColors.buttonColor,
                  ),
                  SizedBox(width: w * 0.1),
                  Expanded(
                      child: Text(
                          "Add photos from your library or capture with your camera.",
                          style: TextStyle(fontSize: 18)))
                ],
              ),
              SizedBox(height: h * 0.03),
              Row(
                children: [
                  Icon(
                    Icons.move_down_outlined,
                    color: AppColors.buttonColor,
                  ),
                  SizedBox(width: w * 0.1),
                  Expanded(
                      child: Text(
                    "Arrange your photos in your desired order",
                    style: TextStyle(fontSize: 18),
                  ))
                ],
              ),
              SizedBox(height: h * 0.03),
              Row(
                children: [
                  Icon(
                    Icons.keyboard_voice_rounded,
                    color: AppColors.buttonColor,
                  ),
                  SizedBox(width: w * 0.1),
                  Expanded(
                      child: Text("Add recordings to each photo",
                          style: TextStyle(fontSize: 18)))
                ],
              ),
              Spacer(),
              CommonButton(
                title: "Add photos",
                buttonMethod: () {

                },
                borderRad: 15,
                loading: false,
                w: w,
                h: h * 0.08,
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
