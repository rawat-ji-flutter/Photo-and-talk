
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_talk/Common/text_styles.dart';

class InboxDetailScreen extends StatefulWidget {
  const InboxDetailScreen({Key? key}) : super(key: key);

  @override
  State<InboxDetailScreen> createState() => _InboxDetailScreenState();
}

class _InboxDetailScreenState extends State<InboxDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(child: Column(
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
        ],
      )),
    );
  }
}
