import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:photo_talk/Common/text_styles.dart';
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
            GridView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 50,
                    mainAxisExtent: height * 0.3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {},
                      child: Column(children: [
                        Stack(
                          children: [
                            Container(
                              width: 150.0,
                              height: height * 0.22,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 15,
                                      spreadRadius: 1.0)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/images/thumb.jpg",
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         AutoSizeText(
                                          "Test video",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          minFontSize: 15,
                                          maxFontSize: 18,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2),
                                         AutoSizeText(
                                          "a month ago",
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          minFontSize: 10,
                                          maxFontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                         SizedBox(height: 2),
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             AutoSizeText(
                                               "By Bipin Rawat",
                                               style: TextStyle(
                                                 color: Colors.grey,
                                               ),
                                               minFontSize: 10,
                                               maxFontSize: 12,
                                               overflow: TextOverflow.ellipsis,
                                             ),
                                             CircleAvatar(
                                               radius: 10,
                                               backgroundColor: Colors.red,
                                               child: Text("B",style: TextStyle(fontSize: 10,color: Colors.white),),
                                             ),
                                           ],
                                         ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        "New",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    )))
                          ],
                        ),
                      ]));
                }),
          ],
        ),
      ),
    );
  }
}
