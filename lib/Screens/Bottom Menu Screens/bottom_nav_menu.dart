//@dart=2.9
import 'package:flutter/material.dart';
import 'package:photo_talk/Common/exit_alert.dart';
import 'package:photo_talk/Common/no_internet.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/dashBoard.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/my_account.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/new_project1.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/pick_images_screen.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/my_videos.dart';
import 'package:photo_talk/Screens/Bottom%20Menu%20Screens/search_screen.dart';
import 'package:photo_talk/Services/internet_service.dart';
import 'package:photo_talk/Widgets/app_colors.dart';
import 'package:provider/provider.dart';

import '../../Widgets/nav.dart';

class BottomNavMenu extends StatefulWidget {
  final int currentIndex;
  final name;
  const BottomNavMenu({Key key, this.currentIndex, this.name})
      : super(key: key);

  @override
  State<BottomNavMenu> createState() => _BottomNavMenuState();
}

class _BottomNavMenuState extends State<BottomNavMenu>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();
  static final List<Widget> _widgetOptions = <Widget>[
    DashBoard(),
    MyAccount(),
  ];

  TextEditingController _textFieldController = TextEditingController();

  @override
  void didChangeDependencies() async {
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _selectedIndex = widget.currentIndex;
    // TODO: implement initState
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => ExitAlertDialog().showexitpop(context),
        child: Scaffold(
          body: Consumer<ConnectivityProvider>(
            builder: (context, value, child) {
              if (value.isOnline != null) {
                return value.isOnline
                    ? Center(
                        child: _widgetOptions.elementAt(_selectedIndex),
                      )
                    : NoInternet();
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          bottomNavigationBar: FABBottomAppBar(
            color: Colors.grey,
            selectedColor: Colors.red,
            notchedShape: CircularNotchedRectangle(),
            onTabSelected: _onItemTapped,
            items: [
              FABBottomAppBarItem(iconData: Icons.home_outlined, text: 'Home'),
              FABBottomAppBarItem(
                  iconData: Icons.person_outline_outlined, text: 'Account'),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFab(context),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.buttonColor,
      onPressed: () {
        _displayTextInputDialog(context);
      },
      tooltip: 'New Project',
      elevation: 2.0,
      child: Icon(Icons.add),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          title: Text('Enter your project name'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _textFieldController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: "Project name"),
              validator: (value) {
                if (value.isEmpty || value == null) {
                  return "Please enter a project name";
                } else {
                  return null;
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(color: AppColors.buttonColor),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: AppColors.buttonColor),
              ),
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                } else {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              NewProject1(
                                projectName: _textFieldController.text.toString(),
                              ))
                  ).then((value) {
                    setState(() {
                      _textFieldController.clear();
                    });
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
