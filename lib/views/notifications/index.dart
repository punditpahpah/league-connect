import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/profile/index.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FriendRequest.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(base_url +
        "get_notifications.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];

    for (var u in JsonData) {
      Items item = Items(u["user_id"], u["user_name"], u["user_profile"],
          u["message"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  var user_id;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {});
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
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: CustomColors.DarkBlueColour,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size.width * 0.08),
                          bottomRight: Radius.circular(size.width * 0.08))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.03,
                      ),
                      CustomTextWidget(
                          text: 'Notifications',
                          fontsize: 0.03,
                          isbold: true,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start),
                      SizedBox(
                        height: 5,
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => FriendRequest()),
                      //     );
                      //   },
                      //   child: CircularImage(
                      //       image: 'assets/images/user.jpg',
                      //       mainText: 'Follow Requests',
                      //       text: 'Approve or ignore requests'),
                      // )
                    ],
                  ),
                )),
            SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 11,
              child: FutureBuilder(
                future: GetPhotos(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.white)),
                    );
                  } else if (snapshot.data[0].code == "0") {
                    return Container(
                      child: Center(
                        child: CustomTextWidget(
                            text: "No Notification",
                            fontsize: 0.03,
                            isbold: true,
                            color: Colors.white,
                            textalign: TextAlign.start),
                      ),
                    );
                  } else {
                    return Container(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularImage(
                                    image: snapshot.data[index].user_profile,
                                    mainText: snapshot.data[index].user_name,
                                    text: snapshot.data[index].message,
                                    user_id: snapshot.data[index].user_id)),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularImage extends StatelessWidget {
  CircularImage({
    required this.image,
    required this.mainText,
    required this.text,
    required this.user_id,
    Key? key,
  }) : super(key: key);
  String text, mainText, image, user_id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => FriendRequest()),
          // );
          Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Profile(user_id: user_id)),
                      );
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => SingleUserChat()),
          //   );
        },
        child: Row(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: image != "Empty"
                        ? image
                        : "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: mainText,
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: text,
                          fontsize: 0.02,
                          isbold: false,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class Items {
  final String user_id;
  final String user_name;
  final String user_profile;
  final String message;
  final String code;
  Items(
      this.user_id, this.user_name, this.user_profile, this.message, this.code);
}
