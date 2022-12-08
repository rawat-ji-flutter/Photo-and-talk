//@dart=2.9
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Common/IOS_confirmation_dialog.dart';
import 'package:photo_talk/Common/android_confirm_dialog.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Screens/Auth%20Screens/intro_screen.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/My%20Account%20Screens/edit_profile.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/My%20Account%20Screens/setting_page.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../Common/snackbar.dart';


class MyAccount extends StatefulWidget {
  const MyAccount({Key key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  var file;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _imagePicker = ImagePicker();
  File pickedImage;

  Future pickSingleImage1(int selectedMethod) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      XFile image = await _imagePicker.pickImage(
          source:
              selectedMethod == 0 ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 20);
      if (image != null) {
        ProgressDialog pd = ProgressDialog(context: context);
        pd.show(
          progressValueColor: AppColors.buttonColor,
          msg: 'Uploading profile picture',
          progressBgColor: Colors.grey,
        );
        file = File(image.path);
   /*     setState(() {*/
          authProvider.updateUserProfileImage(file: file).then((value) {
            pd.close();
            Common().showCommonSnackbar(
                context: context, msg: "Profile Updated Successfully");
            setState(() {

            });
          }).onError((error, stackTrace) {
            pd.close();
            print(error);
            print("error");
            Common()
                .showCommonSnackbar(context: context, msg: error.toString());
          });
        // });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: authProvider,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "Something went wrong !",
                  style: mainBoldHeading(),
                ));
              } else {
                return Container(
                  height: h,
                  width: w,
                  color: Color(0xfff2f5fa),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0,bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Account",
                            style: mainWorkSansHeading()
                        ),
                     Expanded(
                       child: SingleChildScrollView(
                         child: Column(
                           children: [
                             SizedBox(height: h * 0.04),
                             Center(
                               child: Column(
                                 children: [
                                   Stack(
                                     children: [
                                       CircleAvatar(
                                         backgroundColor: AppColors.buttonColor,
                                         radius: 60,
                                         child: CircleAvatar(
                                             backgroundColor: Colors.white,
                                             radius: 58,
                                             foregroundImage: snapshot
                                                 .data.docs[0]["imageURL"]
                                                 .toString() ==
                                                 null
                                                 ? FileImage(file) as ImageProvider
                                                 : NetworkImage(snapshot
                                                 .data.docs[0]["imageURL"]
                                                 .toString()),
                                             backgroundImage: const AssetImage(
                                                 "assets/images/placeholder.png")),
                                       ),
                                       Positioned(
                                         bottom: 4.0,
                                         right: 4.0,
                                         child:
                                         InkWell(
                                           onTap: () {
                                             showModalBottomSheet(
                                               context: context,
                                               builder: ((builder) =>
                                                   bottomSheet(context)),
                                             );
                                           },
                                           child: const
                                           CircleAvatar(
                                             backgroundColor: AppColors.buttonColor,
                                             radius: 17,
                                             child: CircleAvatar(
                                               backgroundColor:
                                               AppColors.buttonColor,
                                               radius: 16,
                                               child: Icon(
                                                 Icons.camera_alt_outlined,
                                                 color: Colors.white,
                                                 size: 22.0,
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                   SizedBox(height: h * 0.02),
                                   AutoSizeText(
                                     snapshot.data.docs[0]["name"].toString(),
                                     style:
                                       GoogleFonts.workSans(
                                           fontWeight: FontWeight.bold, fontSize: 22
                                       )
                                   ),
                                   SizedBox(height: h*0.01),
                                   AutoSizeText(
                                     snapshot.data.docs[0]["phoneNo"].toString(),
                                     style: GoogleFonts.lato(
                                         fontWeight: FontWeight.w400, fontSize: 18,color: Colors.grey
                                     )
                                   ),
                                 ],
                               ),
                             ),
                             SizedBox(height: h * 0.04),
                            // const Spacer(),
                             Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(15),
                                   color: Colors.white),
                               child: Padding(
                                 padding: const EdgeInsets.all(12.0),
                                 child: Column(
                                   children: [
                                     SizedBox(height: h * 0.015),
                                     GestureDetector(
                                       onTap: () {
                                         Navigator.of(context)
                                             .push(MaterialPageRoute(
                                             builder: (context) => EditProfile(
                                               name: snapshot
                                                   .data.docs[0]["name"]
                                                   .toString(),
                                               email: snapshot
                                                   .data.docs[0]["email"]
                                                   .toString(),
                                               imgUrl: snapshot.data.docs[0]["imageURL"].toString(),
                                             )))
                                             .then((value) {
                                           setState(() {});
                                         });
                                       },
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           const SizedBox(
                                             width: 10,
                                           ),
                                           const Icon(Icons.person_outline_outlined,
                                               color: AppColors.buttonColor),
                                           const SizedBox(
                                             width: 20,
                                           ),
                                           AutoSizeText(
                                             "Edit",
                                             style:buttonStyle()
                                           ),
                                           const Spacer(),
                                           const Icon(
                                             Icons.arrow_forward_ios_outlined,
                                             color: AppColors.buttonColor,
                                             size: 17,
                                           ),
                                           const SizedBox(
                                             width: 10,
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(height: h * 0.015),
                                     const Divider(thickness: 1),
                                     SizedBox(height: h * 0.015),
                                     GestureDetector(
                                       onTap: () {
                                         // Navigator.of(context)
                                         //     .push(MaterialPageRoute(
                                         //     builder: (context) => CreateAccount(
                                         //       phoneNumber: "11111111",
                                         //     )));
                                       },
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           const SizedBox(
                                             width: 10,
                                           ),
                                           const Icon(Icons.question_answer_outlined,
                                               color: AppColors.buttonColor),
                                           const SizedBox(
                                             width: 20,
                                           ),
                                           AutoSizeText(
                                             "FAQ",
                                             style: buttonStyle()
                                           ),
                                           const Spacer(),
                                           const Icon(
                                             Icons.arrow_forward_ios_outlined,
                                             color: AppColors.buttonColor,
                                             size: 17,
                                           ),
                                           const SizedBox(
                                             width: 10,
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(height: h * 0.015),
                                     const Divider(thickness: 1),
                                     SizedBox(height: h * 0.015),
                                     Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceBetween,
                                       children: [
                                         const SizedBox(
                                           width: 10,
                                         ),
                                         const Icon(Icons.share_outlined,
                                             color: AppColors.buttonColor),
                                         const SizedBox(
                                           width: 20,
                                         ),
                                         AutoSizeText(
                                           "Share",
                                           style: buttonStyle(),),
                                         const Spacer(),
                                         const Icon(
                                           Icons.arrow_forward_ios_outlined,
                                           color: AppColors.buttonColor,
                                           size: 17,
                                         ),
                                         const SizedBox(
                                           width: 10,
                                         ),
                                       ],
                                     ),
                                     SizedBox(height: h * 0.015),
                                     const Divider(thickness: 1),
                                     SizedBox(height: h * 0.015),
                                     GestureDetector(
                                       onTap: () {
                                         Navigator.of(context).push(
                                             MaterialPageRoute(
                                                 builder: (context) =>
                                                 const SettingPage()));
                                       },
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           const SizedBox(
                                             width: 10,
                                           ),
                                           const Icon(Icons.settings_outlined,
                                               color: AppColors.buttonColor),
                                           const SizedBox(
                                             width: 20,
                                           ),
                                           AutoSizeText(
                                             "Settings",
                                             style: buttonStyle()
                                           ),
                                           const Spacer(),
                                           const Icon(
                                             Icons.arrow_forward_ios_outlined,
                                             color: AppColors.buttonColor,
                                             size: 17,
                                           ),
                                           const SizedBox(
                                             width: 10,
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(height: h * 0.015),
                                     const Divider(thickness: 1),
                                     SizedBox(height: h * 0.015),
                                     GestureDetector(
                                       onTap: () async {
                                         Platform.isAndroid
                                             ? await AndroidConfirmationDialog(
                                             buttonLabel: "YES",
                                             negButtonLabel: "NO",
                                             dialogHeight: h * 0.12,
                                             ctx: context,
                                             buttonResponse: () async {
                                               Navigator.pop(context);
                                               await FirebaseAuth.instance
                                                   .signOut()
                                                   .then((value) {
                                                 Navigator.pushAndRemoveUntil(
                                                     context,
                                                     MaterialPageRoute(
                                                         builder: (BuildContext
                                                         context) =>
                                                         const IntroSlides()),
                                                         (Route<dynamic> route) =>
                                                     false);
                                               });
                                             },
                                             label:
                                             "Are you sure you want to sign out?")
                                             : await IosConfirmationDialog(
                                           label:
                                           "Are you sure you want to sign out",
                                           negButtonLabel: "NO",
                                           buttonLabel: "YES",
                                           ctx: context,
                                           buttonResponse: () async {
                                             Navigator.pop(context);
                                             await FirebaseAuth.instance
                                                 .signOut()
                                                 .then((value) {
                                               Navigator.pushAndRemoveUntil(
                                                   context,
                                                   MaterialPageRoute(
                                                       builder: (BuildContext
                                                       context) =>
                                                       const IntroSlides()),
                                                       (Route<dynamic> route) =>
                                                   false);
                                             });
                                           },
                                         );
                                       },
                                       child: Row(
                                         mainAxisAlignment:
                                         MainAxisAlignment.spaceBetween,
                                         children: [
                                           const SizedBox(
                                             width: 10,
                                           ),
                                           const Icon(Icons.logout,
                                               color: AppColors.buttonColor),
                                           const SizedBox(
                                             width: 20,
                                           ),
                                           AutoSizeText(
                                             "Logout",
                                             style: buttonStyle()
                                           ),
                                           const Spacer(),
                                           const Icon(
                                             Icons.arrow_forward_ios_outlined,
                                             color: AppColors.buttonColor,
                                             size: 17,
                                           ),
                                           const SizedBox(
                                             width: 10,
                                           ),
                                         ],
                                       ),
                                     ),
                                     SizedBox(height: h * 0.015),
                                   ],
                                 ),
                               ),
                             ),
                             SizedBox(height: h * 0.04)
                           ],
                         ),
                       ),
                     ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 8,
                                  child: Text("7",style: TextStyle(color: Colors.white,fontSize: 10),)
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }

  /// bottomSheet with image picking option

  Widget bottomSheet(context) {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose profile picture",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.buttonColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                pickSingleImage1(0);
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.buttonColor,
              ),
              onPressed: () {
                Navigator.pop(context);
                pickSingleImage1(1);
                //takePhoto(imageType, ImageSource.gallery, context);
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  TextStyle buttonStyle(){
    return GoogleFonts.lato(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Colors.grey[800]
    );
  }
}
