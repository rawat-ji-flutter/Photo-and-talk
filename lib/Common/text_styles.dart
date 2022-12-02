import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


TextStyle Header() {
  return const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,);
}

TextStyle mainBoldHeading() {
  return const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 18.0,);
}

TextStyle mainWorkSansHeading() {
  return  GoogleFonts.workSans(
      fontWeight: FontWeight.bold, fontSize: 30
  );
}

TextStyle buttonWorkSansHeading() {
  return  GoogleFonts.workSans(
      fontWeight: FontWeight.w600,
      fontSize: 18
  );
}



TextStyle subHeading() {
  return const TextStyle(
    fontSize: 14.0,);
}