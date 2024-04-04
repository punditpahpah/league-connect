import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/views/home/index.dart';
import 'package:dating_app/views/initialScreen.dart/initialScreen.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  var user_id;
  var is_logged_in;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    is_logged_in = prefs.getString('is_logged_in');
    setState(() {
      if(is_logged_in=="yes"){
        var route = new MaterialPageRoute(
          builder: (BuildContext context) => new Home());
      Navigator.of(context).push(route);
      }
    });
  }

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: GradientbackgroundColour(),
        child: GestureDetector(
          onTap: () {
             Navigator.pushNamed(context, AppRoutes.INITIALSCREEN);
          },
          child: Center(
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo.png',
                width: size.width * 0.75,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
