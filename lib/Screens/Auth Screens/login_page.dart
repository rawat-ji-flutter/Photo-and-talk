//@dart=2.9
import 'package:country_calling_code_picker/picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Screens/Auth%20Screens/otp_screen.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String enterText;
  final _formKey = GlobalKey<FormState>();
  bool isButtonClicked = false;
  var code = '';
  var countryCode = "+46";

  bool isSignedIn = false;
  var phoneNumber;
  var verifyId;

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  void _showCountryPicker({context}) async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        countryCode = country.callingCode.toString();
      });
    }
  }

  Future<void> sendOtp() async {
    setState(() {
      isButtonClicked = true;
    });
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          // phoneNumber:"+91 ${phoneNumberController.text}",
          phoneNumber: "$countryCode ${phoneNumberController.text}",
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            Common().showCommonSnackbar(
                context: context,
                msg: "Something went wrong ! Please try again later.");
            print(e);
            setState(() {
              isButtonClicked = false;
            });
          },
          codeSent: (String verificationId, int resendToken) {
            verifyId = verificationId;
            Common().showCommonSnackbar(
                context: context, msg: "OTP sent successfully");
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => OtpScreen(
            //           verifId: verificationId,
            //           number: phoneNumberController.text,
            //         )
            // )
            // );
            setState(() {
              isSignedIn = true;
              isButtonClicked = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      Common()
          .showCommonSnackbar(msg: "Something went wrong !", context: context);
    } finally {}
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.buttonColor),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final focusedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  final submittedPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.green),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/login_bg.jpg"),
                      fit: BoxFit.cover,
                      opacity: 1.0)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.05),
                    Image.asset(
                      "assets/images/photo-to-talk-logo.png",
                      height: height * 0.15,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: height * 0.45,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                          isSignedIn == true
                              ? "Enter your otp here"
                              : "Sign in",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: height * 0.04),
                      isSignedIn == true
                          ? Column(
                              children: [
                                Pinput(
                                  length: 6,
                                  onChanged: (v) {
                                    code = v;
                                  },
                                  showCursor: true,
                                  onCompleted: (pin) => print(pin),
                                  closeKeyboardWhenCompleted: true,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  defaultPinTheme: defaultPinTheme,
                                ),
                                SizedBox(height: height * 0.05),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Is this wrong number ? "),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isSignedIn = false;
                                          });
                                        },
                                        child: Text("Change number",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold))),
                                  ],
                                )
                              ],
                            )
                          : Container(
                              height: 50,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: AppColors.buttonColor),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: Colors.grey[200]
                                        ),
                                        // constraints: const BoxConstraints.expand(),
                                        child: Column(
                                          children: [
                                            Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                _showCountryPicker(
                                                    context: context);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    countryCode.toString(),
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .arrow_drop_down_outlined,
                                                    size: 15,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    flex: 4,
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        controller: phoneNumberController,
                                        validator: (value) {
                                          if (value.isEmpty || value == null) {
                                            return "Please enter your mobile number";
                                          } else if (value.length < 9) {
                                            return "Please enter a valid number";
                                          } else {
                                            return null;
                                          }
                                        },
                                        onChanged: (value) {
                                          enterText = value;
                                          if (value.length == 9) {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        maxLength: 9,
                                        decoration: InputDecoration(
                                          fillColor: Colors.grey[200],
                                          filled: true,
                                          hintText: "Enter your phone number",
                                          // prefix: const Text('+46 '),
                                          counterText: "",
                                          //prefixIcon: Icon(Icons.flag),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 15, 30, 15),
                                          labelStyle: TextStyle(
                                              letterSpacing: 2,
                                              color: Colors.black),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: AppColors.buttonColor,
                                            ),
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      // Row(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           GestureDetector(
                      //             onTap: () {
                      //               _showCountryPicker(context: context);
                      //             },
                      //             child: Container(
                      //                 width: width * 0.2,
                      //                 height: height * 0.06,
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.grey[200],
                      //                   border: Border.all(
                      //                       color: AppColors.buttonColor
                      //                   ),
                      //                   borderRadius: BorderRadius.circular(25),
                      //                 ),
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Row(
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.center,
                      //                     children: [
                      //                       Text(countryCode.toString()),
                      //                       Icon(
                      //                         Icons.arrow_drop_down_outlined,
                      //                         size: 20,
                      //                         color: Colors.black,
                      //                       )
                      //                     ],
                      //                   ),
                      //                 )),
                      //           ),
                      //           SizedBox(width: width * 0.02),
                      //           Container(
                      //             width: width * 0.68,
                      //             height: height * 0.08,
                      //             child: Form(
                      //               key: _formKey,
                      //               child: TextFormField(
                      //                 controller: phoneNumberController,
                      //                 validator: (value) {
                      //                   if (value.isEmpty || value == null) {
                      //                     return "Please enter your mobile number";
                      //                   } else if (value.length < 9) {
                      //                     return "Please enter a valid number";
                      //                   } else {
                      //                     return null;
                      //                   }
                      //                 },
                      //                 onChanged: (value) {
                      //                   enterText = value;
                      //                   if (value.length == 9) {
                      //                     FocusScope.of(context).unfocus();
                      //                   }
                      //                 },
                      //                 keyboardType: TextInputType.number,
                      //                 maxLength: 9,
                      //                 decoration: InputDecoration(
                      //                   fillColor: Colors.grey[200],
                      //                   filled: true,
                      //                   hintText: "Enter your phone number",
                      //                   // prefix: const Text('+46 '),
                      //                   counterText: "",
                      //                   //prefixIcon: Icon(Icons.flag),
                      //                   contentPadding:
                      //                       EdgeInsets.fromLTRB(15, 15, 30, 15),
                      //                   labelStyle: TextStyle(
                      //                       letterSpacing: 2,
                      //                       color: Colors.black),
                      //                   border: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(25),
                      //                   ),
                      //                   enabledBorder: OutlineInputBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(25.0),
                      //                     borderSide: BorderSide(
                      //                       color: AppColors.buttonColor,
                      //                     ),
                      //                   ),
                      //                   floatingLabelBehavior:
                      //                       FloatingLabelBehavior.always,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      Spacer(),
                      isSignedIn == true
                          ? Consumer<AuthProvider>(
                              builder: (context, provider, child) {
                                return CommonButton(
                                    borderRad: 20,
                                    buttonMethod: () {
                                      provider.verifyOTP(
                                          context: context,
                                          smsCode: code,
                                          phNumber: phoneNumberController.text,
                                          verificationID: verifyId.toString());
                                    },
                                    h: height * 0.07,
                                    w: width,
                                    title: "Verify OTP",
                                    loading: provider.isOTPLoading);
                              },
                            )
                          : CommonButton(
                              borderRad: 25,
                              buttonMethod: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                } else {
                                  return await sendOtp();
                                }
                              },
                              h: height * 0.062,
                              w: width,
                              title: "Sign In",
                              loading: isButtonClicked),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
