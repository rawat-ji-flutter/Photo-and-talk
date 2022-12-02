import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class SelectLanguageScreen extends StatefulWidget {
  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool eng = false;
  bool swe = false;

  TextStyle buttonStyle() {
    return GoogleFonts.lato(fontSize: 18, color: Colors.grey[800]);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: h,
          width: w,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Platform.isAndroid
                        ? IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.black,
                            ))
                        : IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 30,
                              color: Colors.black,
                            )),
                    Text("Select language", style: mainWorkSansHeading()),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      eng = true;
                      swe = false;
                    });
                  },
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage("assets/images/eng_logo.png"),
                            ),
                            SizedBox(width: w * 0.05),
                            Text(
                              'English',
                              style: buttonStyle(),
                            ),
                            Spacer(),
                            eng == true
                                ? Icon(
                                    Icons.done,
                                    color: AppColors.buttonColor,
                                  )
                                : Container()
                          ],
                        ),
                      )),
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      eng = false;
                      swe = true;
                    });
                  },
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage("assets/images/sweden_logo.png"),
                            ),
                            SizedBox(width: w * 0.05),
                            Text(
                              'Swedish',
                              style: buttonStyle(),
                            ),
                            Spacer(),
                            swe == true
                                ? Icon(
                                    Icons.done,
                                    color: AppColors.buttonColor,
                                  )
                                : Container()
                          ],
                        ),
                      )),
                ),
                Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
