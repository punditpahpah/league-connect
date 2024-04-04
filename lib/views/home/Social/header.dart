import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/login/login/index.dart';
import 'package:dating_app/views/profile/index.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class header extends StatefulWidget {
  header({Key? key}) : super(key: key);
  @override
  _headerState createState() => _headerState();
}

class _headerState extends State<header> {
  String user_profile = "https://i.stack.imgur.com/y9DpT.jpg";
  Future GetProfileData() async {
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "get_profile_data.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    user_profile = data[0]['user_profile'];
    setState(() {});
  }

  var user_id;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {
      GetProfileData();
    });
  }

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.CHAT);
                  },
                  icon: Icon(
                    Icons.sms,
                    color: CustomColors.WhiteColour,
                  )),
              Image.asset('assets/images/logo.png'),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile(user_id: user_id,)),
                  );
                },
                child: Container(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loading.gif',
                      image: user_profile != "Empty"
                          ? user_profile
                          : "https://i.stack.imgur.com/y9DpT.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async{
                  SharedPreferences preferences =
                  await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false);
                },
                child: Icon(Icons.logout,
                color: Colors.white,
                size: 20,),
              ),
            ],
          ),
        ));
  }
}
