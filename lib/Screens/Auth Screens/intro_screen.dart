import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_talk/Models/intro_slider_model.dart';
import 'package:photo_talk/Screens/Auth%20Screens/login_page.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:photo_talk/Widgets/responsive_widget.dart';

class IntroSlides extends StatefulWidget {
  const IntroSlides({super.key});

  @override
  _IntroSlidesState createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  List<SliderModel> slides = <SliderModel>[];
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
    slides = getSlides();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                    scrollDirection: Axis.horizontal,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    controller: _controller,
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      // contents of slider
                      return GestureDetector(
                          onTap: () {
                            if (index != slides.length - 1) {
                              _controller!.nextPage(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.ease);
                            }
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            alignment: Alignment.topCenter,
                            children: [
                              Image(
                                  image: AssetImage(slides[index].getImage()!),
                                  fit: BoxFit.cover),
                              Positioned(
                                  top: h * 0.1,
                                  child: SizedBox(
                                    width: w,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          slides[index].getTitle()!,
                                          style: TextStyle(
                                              fontSize: !ResponsiveWidget
                                                      .isSmallScreen(context)
                                                  ? 45
                                                  : 28,
                                              color: AppColors.secondaryColor,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start,
                                        ),
                                        Text(
                                          slides[index].getSubTitle(),
                                          style: TextStyle(
                                              fontSize: !ResponsiveWidget
                                                      .isSmallScreen(context)
                                                  ? 35
                                                  : 16,
                                              color: index == 1
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ));
                    }),
                Positioned(
                    bottom: 20,
                    right: 20,
                    child: IconButton(
                      onPressed: () {
                        if (_controller!.page != 2) {
                          _controller!.nextPage(
                              duration: const Duration(seconds: 1),
                              curve: Curves.ease);
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LoginScreen(
                              )));
                        }
                      },
                      icon: Icon(
                        Platform.isAndroid
                            ? Icons.arrow_forward_sharp
                            : Icons.arrow_forward_ios,
                        color: AppColors.secondaryColor,
                        size: 30,
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? Colors.orange : Colors.grey,
      ),
    );
  }
}

class Slider extends StatelessWidget {
  String? image;

  Slider({this.image});

  @override
  Widget build(BuildContext context) {
    return Image(image: AssetImage(image!), fit: BoxFit.cover);
  }
}
