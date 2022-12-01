//@dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/snackbar.dart';
import 'package:photo_talk/Common/text_styles.dart';
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
  List<String> listt = [];
  int selectedOption;
  final ImagePicker _picker = ImagePicker();

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
                                            style: TextStyle(fontSize: 18)))
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
                                      style: TextStyle(fontSize: 18),
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
                                            style: TextStyle(fontSize: 18)))
                                  ],
                                ),
                                SizedBox(height: h * 0.1),
                              ],
                            )
                          : gridView(),
                      SizedBox(height: h * 0.02),
                      CommonButton(
                        title: imageArray.length >= 6 && imageArray.isNotEmpty
                            ? "Start Recording"
                            : "Add",
                        buttonMethod: () {
                          imageArray.length >= 6 && imageArray.isNotEmpty
                              ? Common().showCommonSnackbar( msg: "Work in progress",context: context)
                              : showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
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
          listt.add(image.toString());
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
          listt.add(_imageFileList.toString());
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
            ?
        imageArray.length >= 6
                ? Container()
                : Container(
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
                  Draggable(
                    feedback: Container(
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
                    child: Container(
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
    return Container(
      height: 400,
      child: ReorderableGridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: imageArray
            .asMap()
            .map((i, dynamic path) => MapEntry(
                  i,
                  Card(
                      key: ValueKey(path),
                      child:
                      (i == imageArray.length)
                          ?
                      imageArray.length >= 6
                          ? Container()
                          : Container(
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
                              File(path.path ?? ""),
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
                                  // imageArray.removeAt(index);
                                  // setState(() {});
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
                      )
                      ),
                ))
            .values
            .toList(),
        onReorder: (oldIndex, newIndex) {
          String path = imagePaths.removeAt(oldIndex);
          imagePaths.insert(newIndex, path);
          setState(() {});
        },
      ),
    );
  }

  List<String> imagePaths = [
    'https://images.unsplash.com/photo-1524024973431-2ad916746881?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1444845026749-81acc3926736?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=864&q=80',
    'https://images.unsplash.com/photo-1535591273668-578e31182c4f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1504472478235-9bc48ba4d60f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
    'https://images.unsplash.com/photo-1520301255226-bf5f144451c1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=873&q=80',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
    'https://images.unsplash.com/photo-1602000737534-f5d2bd78a78b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1032&q=80',
    'https://images.unsplash.com/photo-1580777187326-d45ec82084d3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
    'https://images.unsplash.com/photo-1531804226530-70f8004aa44e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
    'https://images.unsplash.com/photo-1465056836041-7f43ac27dcb5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=871&q=80',
    'https://images.unsplash.com/photo-1489311778769-38fbf664895a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1524704796725-9fc3044a58b2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=905&q=80',
    'https://images.unsplash.com/photo-1573553256520-d7c529344d67?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1444930694458-01babf71870c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=963&q=80',
    'https://images.unsplash.com/photo-1571752726703-5e7d1f6a986d?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=865&q=80',
    'https://images.unsplash.com/photo-1514503612056-e3f673b3f3bd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=826&q=80',
    'https://images.unsplash.com/photo-1444464666168-49d633b86797?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=869&q=80',
    'https://images.unsplash.com/photo-1504567961542-e24d9439a724?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
    'https://images.unsplash.com/photo-1506260408121-e353d10b87c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=928&q=80',
    'https://images.unsplash.com/photo-1490750967868-88aa4486c946?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1456926631375-92c8ce872def?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'https://images.unsplash.com/photo-1475809913362-28a064062ccd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
  ];
}
