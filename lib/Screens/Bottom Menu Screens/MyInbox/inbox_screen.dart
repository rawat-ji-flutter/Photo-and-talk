import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/MyInbox/inbox_detail_screen.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/MyInbox/video_player.dart';
import 'package:photo_talk/Widgets/app_colors.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  Map<int, Widget> _children = {
    0: const Text('Received Videos'),
    1: const Text('Sent Videos')
  };

  int _currentSelection = 0;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xfff2f5fa),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_back
                            : Icons.arrow_back_ios,
                        size: 32,
                      )),
                  const SizedBox(width: 5),
                  Text("My Inbox", style: mainWorkSansHeading()),
                ],
              ),
              SizedBox(
                width: w,
                height: h * 0.1,
                child: MaterialSegmentedControl(
                  children: _children,
                  selectionIndex: _currentSelection,
                  borderColor: Colors.grey,
                  selectedColor: AppColors.buttonColor,
                  unselectedColor: Colors.white,
                  borderRadius: 8.0,
                  verticalOffset: 10,
                  onSegmentChosen: (index) {
                    setState(() {
                      _currentSelection = index as int;
                    });
                  },
                ),
              ),
              SizedBox(height: h * 0.02),
              _currentSelection == 0
                  ? buildMainDashboard()
                  : buildMainDashboard()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMainDashboard() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChewieDemo()
                          )
                          );
                        },
                        child: Column(children: [
                          Stack(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 15,
                                        spreadRadius: 1.0)
                                  ],
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height * 0.12,
                                        width: width * 0.35,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/thumb.jpg"),
                                                fit: BoxFit.cover)
                                        ),
                                      ),
                                      SizedBox(height: height * 0.01),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12.0,right: 12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              "Line Wranne",
                                              style: TextStyle(
                                                color: AppColors.buttonColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              minFontSize: 20,
                                              maxFontSize: 22,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 2),
                                            AutoSizeText(
                                              "My trip to England",
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              minFontSize: 11,
                                              maxFontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: height * 0.05),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  "2 weeks ago",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                  minFontSize: 13,
                                                  maxFontSize: 15,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "New",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      )))
                            ],
                          ),
                        ])),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
