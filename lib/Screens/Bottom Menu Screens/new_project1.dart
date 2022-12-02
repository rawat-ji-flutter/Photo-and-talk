//@dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/new_project_2.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class NewProject1 extends StatefulWidget {
  final projectName;
  const NewProject1({Key key, this.projectName}) : super(key: key);

  @override
  State<NewProject1> createState() => _NewProject1State();
}

class _NewProject1State extends State<NewProject1> {
  var image;
  List imageArray = [];
  int selectedOption;
  final ImagePicker _picker = ImagePicker();

  TextStyle infoStyle(){
    return GoogleFonts.lato(
        fontSize: 18,
        color: Colors.grey[800]
    );
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    ),
                    iconSize: 30,
                  ),
                  Expanded(
                    child: Text(widget.projectName.toString(),
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis)),
                  )
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.1),
                      imageArray.length == 0
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.camera_outlined,
                                      color: AppColors.buttonColor,
                                      size: 30,
                                    ),
                                    SizedBox(width: w * 0.1),
                                    Expanded(
                                        child: Text(
                                            "Add photos from your library or capture with your camera.",
                                            style:infoStyle()))
                                  ],
                                ),
                                SizedBox(height: h * 0.06),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.move_down_outlined,
                                      color: AppColors.buttonColor,
                                      size: 30,
                                    ),
                                    SizedBox(width: w * 0.1),
                                    Expanded(
                                        child: Text(
                                      "Arrange your photos in your desired order",
                                      style: infoStyle()
                                    ))
                                  ],
                                ),
                                SizedBox(height: h * 0.06),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.keyboard_voice_rounded,
                                      color: AppColors.buttonColor,
                                      size: 30,
                                    ),
                                    SizedBox(width: w * 0.1),
                                    Expanded(
                                        child: Text(
                                            "Add recordings to each photo",
                                            style: infoStyle()))
                                  ],
                                ),
                                SizedBox(height: h * 0.1),
                              ],
                            )
                          : gridView(),
                      SizedBox(height: h * 0.2),
                      imageArray.length >=6 ?
                          Container()
                      :
                      CommonButton(
                        title: "Add more photos",
                        buttonMethod: () {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet()),
                          );
                        },
                        borderRad: 25,
                        loading: false,
                        w: w,
                        h: h * 0.07,
                      ),
                      SizedBox(height: h * 0.02),
                      imageArray.length == 0 ?
                          Container()
                      :
                      CommonButton(
                        title: "Start Recording",
                        buttonMethod: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => NewProject2(
                          //       images: [imageArray]                             )));
                          Common().showCommonSnackbar(
                              context: context, msg: " Work in progress");
                        },
                        borderRad: 25,
                        loading: false,
                        w: w,
                        h: h * 0.07,
                      ),
                      SizedBox(height: h * 0.05),
                      // Spacer(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickSingleImage() async {
    Navigator.pop(context);
    try {
      image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          imageArray.add(image);
        });
      }
    } catch (e) {
      setState(() {});
    }
  }

  Future pickMultipleImage() async {
    Navigator.of(context).pop();
    try {
      final pickedmultipleimage =
          await _picker.pickImage(source: ImageSource.gallery);
      var _imageFileList = pickedmultipleimage;
      if (_imageFileList != null) {
        setState(() {
          imageArray.add(_imageFileList);
        });
      }
    } catch (e) {
      setState(() {});
    }
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Pictures",
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
                Icons.camera_outlined,
                color: AppColors.buttonColor,
              ),
              onPressed: () {
                selectedOption = 0;
                pickSingleImage();
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.buttonColor,
              ),
              onPressed: () {
                selectedOption = 1;
                pickMultipleImage();
              },
              label: const Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  /// widget for aligned images with add box
  Widget addImageWidget() {
    return AlignedGridView.count(
      itemCount: imageArray.length + 1,
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 50,
      crossAxisSpacing: 50,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        print(imageArray.runtimeType);
        print(imageArray.asMap().toString());
        print("imageArray");
        return (index == imageArray.length)
            ? imageArray.length >= 6
                ? Container()
                :
        Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColors.buttonColor,
                    ),
                    child: Center(
                        child: IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: ((builder) => bottomSheet()),
                        );
                      },
                      icon: const Icon(
                        Icons.add,
                        size: 35,
                        color: Colors.white,
                      ),
                    )))
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                    width: 120,
                    height: 120,
                    child: Image.file(
                      File(imageArray[index].path ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   right: 10,
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         imageArray.removeAt(index);
                  //         setState(() {});
                  //       },
                  //       child: const Icon(Icons.cancel)),
                  // ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: GestureDetector(
                        onTap: () {
                          imageArray.removeAt(index);
                          setState(() {});
                        },
                        child: CircleAvatar(
                          backgroundColor: AppColors.buttonColor,
                          radius: 12,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),

                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         imageArray.removeAt(index);
                  //         setState(() {});
                  //       },
                  //       child: Image.asset("assets/icons/delete.png")),
                  // ),
                ],
              );
      },
    );
  }

  Widget gridView() {
    return ReorderableGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisExtent: 100,
      crossAxisSpacing: 10,
      children:
      imageArray
          .asMap()
          .map((i, dynamic path) => MapEntry(
                i,
                Card(
                  elevation: 2,
                    key: ValueKey(path),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black,
                          ),
                          width: 120,
                          height: 120,
                          child: Image.file(
                            File(path.path ?? ""),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 10,
                          child: GestureDetector(
                              onTap: () {
                                imageArray.removeAt(i);
                                setState(() {});
                              },
                              child: CircleAvatar(
                                backgroundColor: AppColors.buttonColor,
                                radius: 12,
                                child: Text(
                                  "${i + 1}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    )),
              ))
          .values
          .toList(),
      onReorder: (oldIndex, newIndex) {
        XFile path1 = imageArray.removeAt(oldIndex);
        imageArray.insert(newIndex, path1);
        setState(() {});
      },
    );
  }
}
