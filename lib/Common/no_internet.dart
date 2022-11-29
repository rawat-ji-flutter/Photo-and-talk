import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class NoInternet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body:
      SafeArea(
        child: Center(
            child: Lottie.asset("assets/animation/net.json")
        ),
      ),
    );
  }
}