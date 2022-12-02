//@dart=2.9
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:photo_talk/Widgets/responsive_widget.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final name;
  final email;
  final imgUrl;
  const EditProfile({Key key, this.name, this.email, this.imgUrl})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var code = '';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isButtonClicked = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController.text = widget.name;
    emailController.text = widget.email;
    // TODO: implement initState
    super.initState();
  }

  var file;
  final _imagePicker = ImagePicker();
  File pickedImage;

  Future pickSingleImage1(int selectedMethod) async {
    try {
      XFile image = await _imagePicker.pickImage(
          source:
              selectedMethod == 0 ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 20);
      if (image != null) {
        setState(() {
          file = File(image.path);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Color(0xfff2f5fa),
            height: height,
            width: width,
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
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Platform.isAndroid
                                  ? Icons.arrow_back
                                  : Icons.arrow_back_ios,
                              size: 32,
                            )),
                        SizedBox(width: 5),
                        Text(
                          "Edit your profile",
                          style: mainWorkSansHeading(),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.05),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.buttonColor,
                            radius: 60,
                            child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 58,
                                foregroundImage: file != null
                                    ? FileImage(file) as ImageProvider
                                    : NetworkImage(widget.imgUrl),
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
                                  builder: ((builder) => bottomSheet(context)),
                                );
                              },
                              child: const CircleAvatar(
                                backgroundColor: AppColors.buttonColor,
                                radius: 17,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.buttonColor,
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
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onChanged: (value) {},
                            keyboardType: TextInputType.text,
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
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.05),
                    Consumer<AuthProvider>(builder: (context, provider, child) {
                      return CommonButton(
                          borderRad: 25,
                          buttonMethod: () async {
                            if (_formKey.currentState.validate()) {

                              if (file != null) {
                                print("here");
                                var snapshot = await FirebaseStorage.instance
                                    .ref()
                                    .child('userProfileImg/imageName')
                                    .putFile(file);

                                var iUrl = await snapshot.ref.getDownloadURL();
                                provider.updateUserInfo(
                                    name: nameController.text,
                                    email: emailController.text,
                                    iFile: iUrl.toString(),
                                    context: context);
                              } else {
                                print("ggg");
                                provider.updateUserInfo(
                                    name: nameController.text,
                                    email: emailController.text,
                                    iFile: widget.imgUrl,
                                    context: context);
                              }
                            }
                          },
                          h: height * 0.07,
                          w: width,
                          title: "Save Changes",
                          loading: provider.isUpdateLoading);
                    }),
                  ],
                ),
              ),
            )),
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
}
