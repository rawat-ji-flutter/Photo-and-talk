import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> CommonDialog(ctx, String error) {
  return showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),

        title: Text(error.toString()),
        //content: Text("You have raised a Alert Dialog Box"),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize: Size(100, 50),
                minimumSize: Size(60, 40),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
