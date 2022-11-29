import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class MyVideos extends StatefulWidget {
  const MyVideos({Key? key}) : super(key: key);

  @override
  State<MyVideos> createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: h,
          width: w,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.backgroundColor1, AppColors.backgroundColor2],
          )),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Spacer(),
                Center(
                  child: Column(
                    children: [
                      Lottie.asset("assets/animation/84655-swinging-sad-emoji.json"),
                      Text(
                        "No Video Found",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                CommonButton(
                    borderRad: 30,
                    buttonMethod: () {
                      createFolder("hello1");
                    },
                    h: h * 0.06,
                    w: w,
                    title: "Create folder",
                    loading: false),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> createFolder(String cow) async {
    final folderName = cow;
    final path = Directory("storage/emulated/0/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
      print("hi 0 ");
    } else {
      path.create();
      print("hi");
      return path.path;
    }
  }
}
