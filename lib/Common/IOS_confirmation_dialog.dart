import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/text_styles.dart';

Future<dynamic> IosConfirmationDialog(
    {required String buttonLabel,
      required String negButtonLabel,
      ctx,
      required String label,
      required VoidCallback buttonResponse,
      required double dialogHeight}) {
  var media = MediaQuery.of(ctx).size;
  double w = media.width;
  double width = MediaQuery.of(ctx).size.width;
  return showCupertinoDialog(
      context: ctx,
      builder: (BuildContext context) => Container(
        width: width *0.87,
        height: dialogHeight,
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 10.0),
        child: CupertinoAlertDialog(
          content: Text(label,style: mainBoldHeading()),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                child: Text(buttonLabel,style: subHeading(),),
                isDestructiveAction: true,
                onPressed: buttonResponse),
            CupertinoDialogAction(
              child: Text(negButtonLabel,style: subHeading(),),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
  );
}
