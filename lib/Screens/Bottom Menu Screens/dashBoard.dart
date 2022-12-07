//@dart=2.9
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/inbox_screen.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/search_screen.dart';
import 'package:photo_talk/Services/provider.dart';
import 'package:provider/provider.dart';

class DashBoard extends StatefulWidget {
  final userName;
  const DashBoard({Key key, this.userName}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var code = '';
  bool isButtonClicked = false;
  TextEditingController _textEditingController = TextEditingController();
  var searchword;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthProvider>(context, listen: false).getUserInfo();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
            future: authProvider,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Color(0xfff2f5fa),
                  height: height,
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(
                              left: 12.0, right: 15.0, bottom: 12.0, top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Image.asset(
                                      "assets/images/photo-to-talk-logo.png",
                                      height: height * 0.12,
                                      width: width * 0.5,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                          builder: (context) => InboxScreen(
                                          )));
                                    },
                                    onDoubleTap: () {
                                      setState(() {
                                        clicked = false;
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 18,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 16,
                                        child: Icon(
                                          Icons.mail_outline_outlined,
                                          color: Colors.black,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // SizedBox(height: height * 0.01),
                              Padding(
                                padding: const EdgeInsets.only(left: 18.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Hi, ",
                                          style: GoogleFonts.workSans(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 30)),
                                      TextSpan(
                                        text: snapshot.data.docs[0]["name"]
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 30,
                                            color: Colors.black,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              Container(
                                height: height*0.06,
                                child: TextField(
                                    enableSuggestions: true,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autocorrect: true,
                                    onSubmitted: (v) {
                                      setState(() {
                                        searchword = v;
                                      });
                                    },
                                    onChanged: (value) {
                                      // getDataForSearch(value);
                                    },
                                    controller: _textEditingController,
                                    decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xFFafafaf),
                                              width: 1.5),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50.0),
                                          ),
                                        ),
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.grey,
                                        ),
                                        filled: true,
                                        hintStyle: new TextStyle(
                                            color: Colors.grey[600]),
                                        hintText: "Search videos",
                                        fillColor: Colors.white)),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              clicked == true
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        buildMainDashboard(),
                                        SizedBox(
                                          height: height * 0.05,
                                        ),
                                      ],
                                    )
                                  : noVideos()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                    child: Text("Error occurred", style: mainBoldHeading()));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  /// widget for search bar
  Widget buildSearchBar({width}) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Container(
          height: 51,
          width: width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFafafaf))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 24),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                      },
                      icon: Icon(
                        Icons.search,
                        size: 25,
                        color: Colors.grey,
                      ))),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen()));
                },
                child: Container(
                    width: 210,
                    child: Text("Search videos",
                        style: TextStyle(
                          color: Color(0xFFafafaf),
                          fontSize: 16,
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMainDashboard() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return
        //   recipes.isEmpty
        //     ? Container(
        //     height: size.height / 2,
        //     child: Center(
        //       child: Text(
        //         Labels.noRecipe,
        //         style: TextStyle(color: blackColor, fontSize: 20),
        //       ),
        //     )
        // )
        //     :
        GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: ScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 50,
                mainAxisExtent: height * 0.3),
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {},
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, top: 10, bottom: 10, right: 5),
                      width: 150.0,
                      height: 160.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                              spreadRadius: 1.0
                          )],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        // image: DecorationImage(
                        //   image: AssetImage(
                        //     "assets/images/video_placeholder.jpg",
                        //   ),
                        // )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //color: Colors.green,
                            height: height * 0.12,
                            width: width,
                            child: Image.asset(
                              "assets/images/video_placeholder.jpg",
                            ),
                          ),
                          Spacer(),
                          AutoSizeText(
                            "Test video",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            minFontSize: 15,
                            maxFontSize: 18,
                            overflow: TextOverflow.ellipsis,
                          ),
                          AutoSizeText(
                            "a month ago",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            minFontSize: 10,
                            maxFontSize: 12,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ]));
            });
  }

  Widget noVideos() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Column(
        children: [
          SizedBox(height: height*0.05),
          Image.asset(
            'assets/images/Phototalk-dash-graphic.png',
            height: height * 0.15,
            width: width,
            //fit: BoxFit.fill,
          ),
          SizedBox(height: height * 0.03),
          Text("No video found",
              style: GoogleFonts.workSans(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 22)),
          SizedBox(height: height * 0.01),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Get started by clicking on the",
                  style: GoogleFonts.lato(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400)),
              Text(
                "red button below! ",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
