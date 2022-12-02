import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_talk/Common/IOS_confirmation_dialog.dart';
import 'package:photo_talk/Common/android_confirm_dialog.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/My%20Account%20Screens/select_language_screen.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {


  TextStyle buttonStyle(){
    return GoogleFonts.lato(
        fontSize: 18,
        color: Colors.grey[800]
    );
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Padding(
              padding:  EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Platform.isAndroid
                              ? Icons.arrow_back
                              : Icons.arrow_back_ios,
                          size: 30,
                          ),
                      ),
                      Text("Settings", style: mainWorkSansHeading())
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SelectLanguageScreen()));
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(Icons.language, size: 30,color: Color(0xffdb3535),),
                            SizedBox(width: 10),
                            Text("Language", style: buttonStyle()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () async {
                      Platform.isAndroid
                          ? await AndroidConfirmationDialog(
                              buttonLabel: "YES",
                              negButtonLabel: "NO",
                              dialogHeight: h * 0.12,
                              ctx: context,
                              buttonResponse: () async {
                                Navigator.pop(context);
                              },
                              label:
                                  "Are you sure you want to delete your account?")
                          : await IosConfirmationDialog(
                              label:
                                  "Are you sure you want to delete your account?",
                              negButtonLabel: "NO",
                              buttonLabel: "YES",
                              ctx: context,
                              buttonResponse: () async {
                                Navigator.pop(context);
                              },
                              dialogHeight: h * 0.12,
                            );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 30,color: Color(0xffdb3535),),
                            SizedBox(width: 10),
                            Text("Delete your account",
                                style: buttonStyle()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
