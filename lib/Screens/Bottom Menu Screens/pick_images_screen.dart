//@dart=2.9
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_talk/Services/merge_provider.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PickImagesScreen extends StatefulWidget {
  final name;
  const PickImagesScreen({Key key, this.name}) : super(key: key);

  @override
  State<PickImagesScreen> createState() => _PickImagesScreenState();
}

class _PickImagesScreenState extends State<PickImagesScreen> {
  var image;
  List imageArray = [];
  int selectedOption;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath);
    print('Recorded file path: $filePath');
  }

  Future playAudio() async {}

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Consumer<MergeProvider>(builder: (context, prov, _) {
        return SafeArea(
          child: SizedBox(
            height: h,
            width: w,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text("Add your images",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  SizedBox(height: h * 0.03),
                  addImageWidget(),
                  // prov.loading
                  //     ? Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CircularProgressIndicator(color: Colors.green),
                  //     SizedBox(width: 15),
                  //     Text('Processing...',
                  //         style: TextStyle(color: Colors.black))
                  //   ],
                  // )
                  //     : Container(),
                  // IconButton(onPressed: ()async{
                  //   await prov.mergeIntoVideo(
                  //     imagesPath: imageArray,
                  //   );
                  // }, icon: Icon(Icons.add)),
                  // GestureDetector(
                  //   onTap: () {
                  //     showModalBottomSheet(
                  //       context: context,
                  //       builder: ((builder) => bottomSheet(context)),
                  //     );
                  //   },
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Container(
                  //         height: 50,
                  //         width: w,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(10),
                  //             border: Border.all(color: Colors.black),
                  //             color: Colors.grey[200]),
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(8.0),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Text("Upload a picture"),
                  //             Icon(Icons.upload)
                  //             ],
                  //           ),
                  //         )
                  //     ),
                  //   ),
                  // ),
                  // image1 == null
                  //     ? Container()
                  //     : Column(
                  //         children: [
                  //           SizedBox(height: h * 0.02),
                  //           Container(
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey[300],
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             child: Stack(
                  //               children: [
                  //                 Row(
                  //                   mainAxisAlignment: MainAxisAlignment.center,
                  //                   children: [
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(20.0),
                  //                       child: Container(
                  //                         height: 100.0,
                  //                         width: 100.0,
                  //                         decoration: BoxDecoration(
                  //                           borderRadius:
                  //                               BorderRadius.circular(15),
                  //                           image: DecorationImage(
                  //                             image:
                  //                                 FileImage(File(image1.path)),
                  //                             fit: BoxFit.fill,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 Positioned(
                  //                     bottom: 10,
                  //                     right: 10,
                  //                     child: GestureDetector(
                  //                         onTap: () {
                  //                           showModalBottomSheet(
                  //                             context: context,
                  //                             builder: ((builder) =>
                  //                                 bottomSheet(context)),
                  //                           );
                  //                         },
                  //                         child: Text(
                  //                           "Change",
                  //                           style: TextStyle(
                  //                             color: AppColors.primaryColor,
                  //                             fontSize: 16,
                  //                             decoration:
                  //                                 TextDecoration.underline,
                  //                           ),
                  //                         ))),
                  //                 Positioned(
                  //                   top: h * 0.01,
                  //                   right: w * 0.02,
                  //                   child: GestureDetector(
                  //                       onTap: () {
                  //                         setState(() {
                  //                           image1 = null;
                  //                         });
                  //                       },
                  //                       child: Icon(Icons.cancel)),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  const Spacer(),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.buttonColor,
                            padding: const EdgeInsets.all(24),
                          ),
                          onLongPress: () async {
                            if (recorder.isRecording) {
                              await stopRecorder();
                              setState(() {});
                            } else {
                              await startRecord();
                              setState(() {});
                            }
                          },
                          onPressed: () {},
                          child: Icon(
                            recorder.isRecording ? Icons.stop : Icons.mic,
                            size: 40,
                          ),
                        ),
                        SizedBox(height: h * 0.03),
                        StreamBuilder<RecordingDisposition>(
                          builder: (context, snapshot) {
                            final duration = snapshot.hasData
                                ? snapshot.data.duration
                                : Duration.zero;

                            String twoDigits(int n) =>
                                n.toString().padLeft(2, '0');

                            final twoDigitMinutes =
                                twoDigits(duration.inMinutes.remainder(60));
                            final twoDigitSeconds =
                                twoDigits(duration.inSeconds.remainder(60));
                            return Text(
                              '$twoDigitMinutes:$twoDigitSeconds',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          stream: recorder.onProgress,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      }),
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
                Icons.camera,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                selectedOption = 0;
                pickSingleImage();
              },
              label: const Text("Camera"),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.image,
                color: AppColors.primaryColor,
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

  ElevatedButton createElevatedButton(
      {IconData icon, Color iconColor, Function onPressFunc}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(6.0),
        side: const BorderSide(
          color: Colors.red,
          width: 4.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        primary: Colors.white,
        elevation: 9.0,
      ),
      onPressed: onPressFunc,
      icon: Icon(
        icon,
        color: iconColor,
        size: 38.0,
      ),
      label: const Text(''),
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
      itemBuilder: (context, index) {
        return (index == imageArray.length)
            ? imageArray.length >= 6
                ? Container()
                : Container(
                    // width: 80,
                    height: 100,
                    color: AppColors.buttonColor,
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
                    color: Colors.black,
                    width: 120,
                    height: 100,
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
                          radius: 12,
                          child: Text("${index + 1}"),
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
}
