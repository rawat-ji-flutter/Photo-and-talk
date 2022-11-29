import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Models/user_model.dart';
import 'package:photo_talk/Screens/Auth%20Screens/create_account_page.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/bottom_nav_menu.dart';
import 'package:photo_talk/Services/shared_pref.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;
  bool isOTPLoading = false;
  bool isUpdateLoading = false;
  var userId;
  var uId;
  var userPhoneNumber;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> changeLoading() async {
    print("inside");
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> changeOTPLoading() async {
    print("inside");
    isOTPLoading = !isOTPLoading;
    notifyListeners();
  }

  Future<void> changeUpdateLoading() async {
    print("inside");
    isUpdateLoading = !isUpdateLoading;
    notifyListeners();
  }

  // Future<void> phoneAuth({required context, required phoneNo}) async {
  //   // try {
  //
  //   changeLoading();
  //   _phoneNo = phoneNo;
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: "+46 ${phoneNo}",
  //       verificationCompleted: (PhoneAuthCredential credential) {
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         changeLoading();
  //         showCommonSnackbaar(context: context, duration: 1,msg: "Something went wrong ! Please try again later.");
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         changeLoading();
  //         _verfificationID = verificationId;
  //         Get.to(OtpVerficationScreen());
  //
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         changeLoading();
  //         showCommonSnackbaar(context: context, duration: 1,msg: "Something went wrong ! Please try again later.");
  //       });
  //   // } catch (e) {
  //   //   // Common()
  //   //   //     .showCommonSnackbar(msg: "Something went wrong !", context: context);
  //   // } finally {
  //   //
  //   // }
  // }

  Future<void> verifyOTP(
      {required context,
      required smsCode,
      required phNumber,
      required verificationID}) async {
    try {
      changeOTPLoading();
      final data = await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationID, smsCode: smsCode));
      await SharedPref().saveNumber(phNumber);
      await SharedPref().saveUid(data.user!.uid);

      print(phNumber);
      print("phNumber");
      final userExist = await FirebaseFirestore.instance
          .collection("users")
          .where("phoneNo", isEqualTo: "+46 $phNumber")
          .get();

      userId = data.user!.uid;
      if (userExist.docs.length != 0) {
        print("here old");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavMenu(
                  currentIndex: 0,
                )));
      } else {
        print("new");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => CreateAccount(
                  phoneNumber: "+46 $phNumber",
                  uid: userId,
                )));
      }
    } catch (e) {
      Common().showCommonSnackbar(
          msg: "Wrong otp ! Please enter a valid otp", context: context);
    } finally {
      changeOTPLoading();
    }
  }

  Future<void> addUser(
      {required context, required file, required infoMap}) async {
    try {
      changeLoading();
      var snapshot = await FirebaseStorage.instance
          .ref()
          .child('userProfileImg/imageName')
          .putFile(file);

      var downloadUrl = await snapshot.ref.getDownloadURL();
      infoMap["imageURL"] = downloadUrl.toString();
      infoMap["docId"] = userId;
      print(userId);
      print("userId inside add user");
      DatabaseModels()
          .addUserInfoToDB(userInfoMap: infoMap, docId: userId)
          .then((value) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => BottomNavMenu(
                  currentIndex: 0,
                )));
      }).onError((error, stackTrace) {
        Common().showCommonSnackbar(context: context, msg: error.toString());
      });
    } catch (e) {
    } finally {
      changeLoading();
    }
  }

  Future<QuerySnapshot> getUserInfo() async {
    final numberHere = await SharedPref().geNumber();
    print(numberHere);
    print("numberHere");
    final data = await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNo", isEqualTo: "+46 $numberHere")
        .get();
    return data;
  }

  Future updateUserInfo(
      {required String name,
      required String email,
      required iFile,
      context}) async {
    try {
      changeUpdateLoading();
    final uidHere = await SharedPref().geUId();
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('userProfileImg/imageName')
        .putFile(iFile);

    var iUrl = await snapshot.ref.getDownloadURL();
    print(userId);
    print("userId inside update");
    return await userCollection.doc(uidHere).update({
      "email": email,
      "name": name,
      "imageURL": iUrl.toString()
    }).then((value) {
      Navigator.pop(context);
      Common().showCommonSnackbar(
          context: context, msg: "Profile Updated Successfully");
    }).onError((error, stackTrace) {
      print(error);
      print("error");
      Common().showCommonSnackbar(context: context, msg: error.toString());
    });
    } catch (e) {

    } finally {
      changeUpdateLoading();
    }
  }

  Future updateUserProfileImage({required file, context}) async {
    final uidHere = await SharedPref().geUId();
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('userProfileImg/imageName')
        .putFile(file);

    var downloadUrl = await snapshot.ref.getDownloadURL();
    return await userCollection
        .doc(uidHere)
        .update({"imageURL": downloadUrl.toString()});
  }

  static UploadTask? uploadFile(String destination, File file) {
    // try {
    final ref = FirebaseStorage.instance.ref(destination);

    return ref.putFile(file);
    // } on FirebaseException catch (e) {
    //   return null;
    // }
  }
}
