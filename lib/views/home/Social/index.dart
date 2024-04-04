import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/home/Social/stories.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';

import 'PostWidget.dart';
import 'header.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

Future<List<Items>> GetPhotos() async {
  var url = Uri.parse(base_url + "get_post.php?auth_key=" + auth_key);
  var Photos = await http.get(url);
  var JsonData = json.decode(Photos.body);
  final List<Items> rows = [];
  //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
  // if snapshot.following_status=="1" then text would be Following
  for (var u in JsonData) {
    Items item = Items(
        u["user_id"],
        u["user_name"],
        u["user_profile"],
        u["post_id"],
        u["post_content"],
        u["post_photo"],
        u["post_likes"],
        u["post_comments"],
        u["code"]);
    rows.add(item);
  }
  return rows;
}

Column PostPictureMethod(context) {
  var size = MediaQuery.of(context).size;
  return Column(
    children: [
      header(),
      Expanded(
          flex: 15,
          child: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    // Expanded(
                    //     flex: 2,
                    //     child: Container(
                    //       child: Text('data'),
                    //     )),
                    //storiesWidget(),
                    // SizedBox(height: 20),
                    WritePostWidget(size: size),
                    SizedBox(height: 20),

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                      child: FutureBuilder(
                        future: GetPhotos(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white)),
                            );
                          } else if (snapshot.data[0].code == "0") {
                            return Container(
                              child: Center(
                                child: CustomTextWidget(
                                    text: "No Posts",
                                    fontsize: 0.03,
                                    isbold: true,
                                    color: Colors.white,
                                    textalign: TextAlign.start),
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              physics: ScrollPhysics(),
                              child: ListView.builder(
                                itemCount: snapshot.data.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      child: postWidget(
                                          user_id: snapshot.data[index].user_id,
                                          user_name:
                                              snapshot.data[index].user_name,
                                          user_profile:
                                              snapshot.data[index].user_profile,
                                          post_id: snapshot.data[index].post_id,
                                          post_content:
                                              snapshot.data[index].post_content,
                                          post_photo:
                                              snapshot.data[index].post_photo,
                                          post_likes:
                                              snapshot.data[index].post_likes,
                                          post_comments: snapshot
                                              .data[index].post_comments,
                                          size: size));
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    ],
  );
}

class WritePostWidget extends StatelessWidget {
  const WritePostWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(left: size.height * 0.03),
            height: size.height * 0.08,
            width: size.width * 0.08,
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage(
                    'assets/images/plus.png',
                  )),
              color: CustomColors.WhiteColour,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
            flex: 7,
            child: Container(
                margin: EdgeInsets.only(right: size.height * 0.03, left: 10),
                padding: EdgeInsets.all(size.height * 0.01),
                height: size.height * 0.06,
                width: size.width * 0.5,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: CustomColors.WhiteColour, width: 1.5),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.CREATEPOST);
                    },
                    child: CustomTextWidget(
                        text: 'What\'s on your mind?',
                        fontsize: 0.025,
                        isbold: false,
                        color: CustomColors.WhiteColour,
                        textalign: TextAlign.start))
                // TextFormField(
                //   style: TextStyle(color: CustomColors.WhiteColour),
                //   decoration: InputDecoration(
                //       floatingLabelBehavior: FloatingLabelBehavior.never,
                //       focusedBorder: InputBorder.none,
                //       enabledBorder: InputBorder.none,
                //       labelText: 'What\'s on your mind?',
                //       labelStyle: TextStyle(color: CustomColors.WhiteColour),
                //       suffixIcon: Icon(
                //         Icons.photo_camera,
                //         color: CustomColors.WhiteColour,
                //       )),
                // ),
                )),
      ],
    );
  }
}

class Items {
  final String user_id;
  final String user_name;
  final String user_profile;
  final String post_id;
  final String post_content;
  final String post_photo;
  final String post_likes;
  final String post_comments;
  final String code;
  Items(
      this.user_id,
      this.user_name,
      this.user_profile,
      this.post_id,
      this.post_content,
      this.post_photo,
      this.post_likes,
      this.post_comments,
      this.code);
}
