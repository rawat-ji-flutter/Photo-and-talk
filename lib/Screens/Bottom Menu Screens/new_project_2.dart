import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewProject2 extends StatefulWidget {
  final List images;
  const NewProject2({Key? key, required this.images}) : super(key: key);

  @override
  State<NewProject2> createState() => _NewProject2State();
}

class _NewProject2State extends State<NewProject2> {

  int currentPos = 0;

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child:
        Container(
          decoration: BoxDecoration(),
          //  color: Colors.green,
          height: h * 0.2,
          width: w,
          child: CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
            itemBuilder: (context, int index, _) {
              print(widget.images);
              print("widget.images");
              return
                  MyImageView(widget.images[index]);
            },
          ),
        ),
      ),
    );
  }
}
class MyImageView extends StatelessWidget {
  final imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child:  Image.file(
        File(imgPath.path),
        fit: BoxFit.cover,
      ),
    );
  }
}
