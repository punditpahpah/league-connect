import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/chat/personChat.dart';

import 'package:dating_app/views/home/Social/stories.dart';
import 'package:dating_app/views/notifications/index.dart';
import 'package:dating_app/views/profile/index.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class chat extends StatefulWidget {
  chat({Key? key}) : super(key: key);
  @override
  _chatState createState() => _chatState();
}

class _chatState extends State<chat> {
  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(base_url +
        "get_chats.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];

    for (var u in JsonData) {
      Items item = Items(u["user_profile"], u["user_real_name"],
          u["message_content"], u["sender_id"], u["receiver_id"], u["code"]);
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
            headerWidget(),
            Expanded(
              flex: 10,
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
                            text: " Say Hi! From Profiles",
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
                          return GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.SINGLEUSERCHAT);
                            },
                            child: Container(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularImage(
                                      image: snapshot.data[index].user_profile,
                                      mainText: snapshot.data[index].user_real_name,
                                      text: snapshot.data[index].message_content,
                                      user_id: snapshot.data[index].sender_id)),
                            ),
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

class chatinfo extends StatelessWidget {
  const chatinfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.SINGLEUSERCHAT);
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        'assets/images/user.jpg',
                      )),
                  color: CustomColors.WhiteColour,
                  shape: BoxShape.circle,
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
                          text: 'Alice',
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.BlackColour,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: 'Hye How are you?',
                          fontsize: 0.02,
                          isbold: true,
                          color: CustomColors.BlackColour.withOpacity(0.5),
                          textalign: TextAlign.start)
                    ],
                  ),
                )),
            Expanded(
                child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColors.GreenColour))),
          ],
        ),
      ),
    );
  }
}

class headerWidget extends StatelessWidget {
  const headerWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                  text: 'Messages',
                  fontsize: 0.025,
                  isbold: true,
                  color: CustomColors.WhiteColour,
                  textalign: TextAlign.center),
            ],
          ),
        ));
  }
}

class Items {
  final String user_profile;
  final String user_real_name;
  final String message_content;
  final String sender_id;
  final String receiver_id;
  final String code;
  Items(this.user_profile, this.user_real_name, this.message_content,
      this.sender_id, this.receiver_id, this.code);
}
