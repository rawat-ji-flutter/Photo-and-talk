//@dart=2.9
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Models/user_model.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/DashBoard.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/bottom_nav_menu.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/pick_images_screen.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:photo_talk/Services/shared_pref.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:photo_talk/Widgets/responsive_widget.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CreateAccount extends StatefulWidget {
  final phoneNumber;
  final uid;
  const CreateAccount({Key key, this.phoneNumber, this.uid}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  var code = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numController = TextEditingController();
  bool isButtonClicked = false;
  final _formKey = GlobalKey<FormState>();
  var file;
  final _imagePicker = ImagePicker();
  File pickedImage;

  Future pickSingleImage1(int selectedmethod) async {
    try {
     XFile image = await _imagePicker.pickImage(
          source:
              selectedmethod == 0 ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 20);
      if (image != null) {

        setState(() {
          file = File(image.path);
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    numController.text = widget.phoneNumber;
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  // Future addUserDetails({String name, String email}) async {
  //   await store.collection("users").add({
  //     "name": name,
  //     "email": email,
  //     "phone no": widget.phoneNumber,
  //     "uid": FirebaseFirestore.instance.collection("users").doc(email).id
  //   });
  // }

  // Future<void> addUser({context, file, infoMap}) async {
  //   var snapshot = await FirebaseStorage.instance
  //       .ref()
  //       .child('userProfileImg/imageName')
  //       .putFile(file);
  //
  //   var downloadUrl = await snapshot.ref.getDownloadURL();
  //   //infoMap["token"] = widget;
  //   infoMap["imageURL"] = downloadUrl.toString();
  //   DatabaseModels().addUserInfoToDB(userInfoMap: infoMap);
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.bgClr,
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
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.05),
                        Text(
                          "Create",
                          style: TextStyle(
                              fontSize: 30,
                              color: AppColors.buttonColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "your account",
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.03),
                        Center(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.buttonColor,
                                radius: 55,
                                child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 53,
                                    foregroundImage: file != null
                                        ?
                                    FileImage(file) as ImageProvider
                                    :
                                    AssetImage(
                                            "assets/images/placeholder.png"),
                                    backgroundImage: const AssetImage(
                                        "assets/images/placeholder.png")),
                              ),
                              Positioned(
                                bottom: 4.0,
                                right: 4.0,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: ((builder) =>
                                          bottomSheet(context)),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: AppColors.buttonColor,
                                    radius: 15,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 13,
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: AppColors.buttonColor,
                                        size: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.01),
                              TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Enter your name",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 30, 15),
                                  labelStyle: TextStyle(
                                      letterSpacing: 2, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              Text(
                                "Email",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.01),
                              TextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Enter your email",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 30, 15),
                                  labelStyle: TextStyle(
                                      letterSpacing: 2, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: height * 0.01),
                              TextFormField(
                                readOnly: true,
                                controller: numController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your number';
                                  }
                                  return null;
                                },
                                onChanged: (value) {},
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Enter your number",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 30, 15),
                                  labelStyle: TextStyle(
                                      letterSpacing: 2, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.15),
                        Consumer<AuthProvider>(
                          builder:(context,provider,child){
                            return
                              CommonButton(
                                borderRad: 25,
                                buttonMethod: () async {
                                  if (!_formKey.currentState.validate()) {
                                    "";
                                  } else if (file == null) {
                                    Common().showCommonSnackbar(
                                        context: context,
                                        msg: "Please upload your profile picture");
                                  } else {
                                    Map<String, dynamic> userData = {
                                      "name":nameController.text,
                                      "phoneNo":numController.text,
                                      "email":emailController.text
                                    };
                                    provider.addUser(context: context, file: file, infoMap: userData);
                                  }
                                },
                                h: height * 0.07,
                                w: width,
                                title: "Submit",
                                loading: provider.isLoading);
                          }
                        ),
                        SizedBox(height: height * 0.5),
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
            "Choose document",
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
}
