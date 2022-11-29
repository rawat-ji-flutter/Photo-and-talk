import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Screens/Auth%20Screens/create_account_page.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/bottom_nav_menu.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/pick_images_screen.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:photo_talk/Services/shared_pref.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:photo_talk/Widgets/responsive_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final verifId;
  final number;
  const OtpScreen({Key? key, this.verifId, this.number}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var code = '';
  var userId;
  bool isButtonClicked = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.backgroundColor1, AppColors.backgroundColor2],
          )),
          height: height,
          width: width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ResponsiveWidget.isSmallScreen(context)
                  ? const SizedBox()
                  : Expanded(
                      child: Container(
                        height: height,
                        child: Center(
                          child: Text(
                            'NS Ventures',
                            style: TextStyle(
                              fontSize: 48.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                  height: height,
                  margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveWidget.isSmallScreen(context)
                          ? height * 0.032
                          : height * 0.12),
                  //  color: AppColors.backColor,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: ' Verify OTP 👇',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25.0,
                                    color: AppColors.buttonColor),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Text(
                          'Hey, Enter your otp to get sign in \nto your account.',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        SizedBox(height: height * 0.2),
                        Pinput(
                          length: 6,
                          onChanged: (v) {
                            code = v;
                          },
                          showCursor: true,
                          onCompleted: (pin) => print(pin),
                          closeKeyboardWhenCompleted: true,
                        ),
                        SizedBox(height: height * 0.1),
                        Consumer<AuthProvider>(
                          builder: (context, provider, child) {
                            return CommonButton(
                                borderRad: 10,
                                buttonMethod: () {
                                  provider.verifyOTP(
                                      context: context, smsCode: code,phNumber:widget.number,verificationID:widget.verifId);
                                },
                                // buttonMethod: () async {
                                //   setState(() {
                                //     isButtonClicked = true;
                                //   });
                                //   try {
                                //     PhoneAuthCredential credential =
                                //         PhoneAuthProvider.credential(
                                //       verificationId: widget.verifId,
                                //       smsCode: code,
                                //     );
                                //     credential.verificationId;
                                //   final data =   await auth.signInWithCredential(credential);
                                //     final userExist = await FirebaseFirestore
                                //         .instance
                                //         .collection("users")
                                //         .where("phoneno",
                                //             isEqualTo: "+46 " + widget.number)
                                //         .get();
                                //     if (userExist.docs.length == 0) {
                                //       userId = data.user!.uid;
                                //       Navigator.of(context)
                                //           .pushReplacement(MaterialPageRoute(
                                //               builder: (context) => CreateAccount(
                                //                     phoneNumber:
                                //                         "+46 " + widget.number,
                                //                   )));
                                //     } else {
                                //       Navigator.of(context)
                                //           .pushReplacement(MaterialPageRoute(
                                //               builder: (context) => BottomNavMenu(
                                //                     currentIndex: 0,
                                //                   )));
                                //     }
                                //   } catch (e) {
                                //     Common().showCommonSnackbar(
                                //         msg: "Wrong otp ! Please enter a valid otp",
                                //         context: context);
                                //   } finally {
                                //     setState(() {
                                //       isButtonClicked = false;
                                //     });
                                //   }
                                // },
                                h: height * 0.07,
                                w: width,
                                title: "Verify OTP",
                                loading: provider.isOTPLoading);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
