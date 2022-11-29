// @dart=2.9
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String tokenKey = "token";
  String nameKey = "name";
  String numberKey = "num";
  String uidKey = "uid";

  Future<void> saveToken(String getToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, getToken);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(tokenKey);
    return token;
  }

  Future<void> clearPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(tokenKey);
    await prefs.clear();
  }

  Future<void> saveName(String fName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(nameKey, fName);
  }

  Future<String> geName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String fName = prefs.getString(nameKey);
    return fName;
  }

  Future<void> saveNumber(String number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(numberKey, number);
  }

  Future<String> geNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString(numberKey);
    return number;
  }

  Future<void> saveUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uidKey, uid);
  }

  Future<String> geUId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString(uidKey);
    return uid;
  }


}
