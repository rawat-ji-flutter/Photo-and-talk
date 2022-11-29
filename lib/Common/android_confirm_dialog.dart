import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> AndroidConfirmationDialog(
    {required String buttonLabel,
      required String negButtonLabel,
      ctx,
      required String label,
      required VoidCallback buttonResponse,
      required double dialogHeight}) {
  var media = MediaQuery.of(ctx).size;
  double w = media.width;

  return showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          actions: <Widget>[
            TextButton(
              onPressed: buttonResponse,
              child: Text(
                buttonLabel,
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                negButtonLabel,
                style: TextStyle(
                  color: Colors.deepOrangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          content: Builder(
            builder: (context) {
              double width = MediaQuery.of(context).size.width;

              return Container(
                width: width * 0.87,
                height: dialogHeight,
                padding: const EdgeInsets.fromLTRB(25, 20, 25, 0.0),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      label, //"Are you Sure You Want To Logout?",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w700),
                    ),
                    Spacer(),
                  ],
                ),
              );
            },
          ),
        );
      },
    ),
  );
}
