import 'package:flutter/material.dart';
import 'package:photo_talk/Common/common_button.dart';
import 'package:photo_talk/Common/no_internet.dart';
import 'package:photo_talk/Common/text_styles.dart';
import 'package:photo_talk/Services/internet_service.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool searchLoader = true;
  TextEditingController _textEditingController = TextEditingController();

  var data;
  var searchword;

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Platform.isIOS
                    ? Icons.arrow_back_ios_outlined
                    : Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("Search your videos",style: mainBoldHeading(),),
          ),
          body:
          Consumer<ConnectivityProvider>(builder: (context, value, child) {
            if (value.isOnline != null) {
              return value.isOnline
                  ? SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    children: [
                      TextField(
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.sentences,
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
                                  color: Colors.deepOrange, width: 1.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15.0),
                              ),
                            ),
                            filled: true,
                            hintStyle:
                            new TextStyle(color: Colors.grey[600]),
                            hintText: "Search videos",
                            fillColor: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //   CalendarButton(),
                      SizedBox(
                        height: 20,
                      ),
                      data == null ? Container() : Container(),
                      CommonButton(
                        borderRad: 10,
                        buttonMethod: () {
                          //getDataForSearch(searchword);
                          FocusScope.of(context).unfocus();
                        },
                        h: h * 0.07,
                        w: w,
                        title: "Search",
                        loading: false,
                      )
                    ],
                  ),
                ),
              )
                  : NoInternet();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
    );
  }
}
