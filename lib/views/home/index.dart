import 'package:dating_app/services/controllers/homenavigation.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/EditProfile/index.dart';
import 'package:dating_app/views/findPartner/index.dart';
import 'package:dating_app/views/maps/index.dart';
import 'package:dating_app/views/notifications/index.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'Social/index.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> _willPopCallback() async {
    SystemNavigator.pop();
    return true;
    // return true if the route to be popped
  }

  @override
  void initState() {
    //getStringValuesSF();
    
    super.initState();
  }

  

  ShowResponse(String Response) {
    Fluttertoast.showToast(
        msg: Response,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    HomeNavigationController homeNavigationController =
        Get.put(HomeNavigationController());

    int _selectedIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        homeNavigationController.count.value = index;
      });
    }

    var size = MediaQuery.of(context).size;
    Widget child = columnwidget('NULL');
    switch (homeNavigationController.returncount().value) {
      case 0:
        child = FindLove();
        break;
      case 1:
        child = MapsScreen();
        break;
      case 2:
        child = PostPictureMethod(context);
        break;
      case 3:
        child = Notifications();
        break;
      case 4:
        child = EditProfile();
        break;
    }
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Container(
          width: size.width * 1,
          height: size.height * 1,
          decoration: GradientbackgroundColour(),
          child: child,
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              //selectedFontSize: 20,
              selectedIconTheme:
                  IconThemeData(color: CustomColors.ButtonColour, size: 40),
              unselectedIconTheme:
                  IconThemeData(color: CustomColors.DarkBlueColour, size: 25),
              selectedItemColor: Colors.amberAccent,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.content_copy),
                  label: 'People',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  label: 'Filter',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.rss_feed_sharp),
                  label: 'New Feeds',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_active),
                  label: 'Notifications',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
              currentIndex: homeNavigationController.count.value, //New
              onTap: _onItemTapped,
            )),
      ),
    );
  }

  Column columnwidget(String text) {
    return Column(
      children: [Text(text)],
    );
  }
}
