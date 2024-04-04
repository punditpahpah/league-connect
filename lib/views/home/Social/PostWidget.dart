import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/home/Social/Comments.dart';
import 'package:dating_app/views/profile/index.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class postWidget extends StatefulWidget {
  postWidget(
      {required this.user_id,
      required this.user_name,
      required this.user_profile,
      required this.post_id,
      required this.post_content,
      required this.post_photo,
      required this.post_likes,
      required this.post_comments,
      required this.size,
      Key? key})
      : super(key: key);

  Size size;
  String user_id,
      user_name,
      user_profile,
      post_id,
      post_content,
      post_photo,
      post_likes,
      post_comments;

  @override
  _postWidgetState createState() => _postWidgetState();
}

class _postWidgetState extends State<postWidget> {
  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(base_url + "get_post.php?auth_key=" + auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item =
          Items(u["post_id"], u["post_content"], u["post_photo"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  ShowResponse(String Response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(Response),
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: widget.size.width * 0.05, vertical: 10),
      decoration: BoxDecoration(
          color: CustomColors.WhiteColour,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Profile(user_id: widget.user_id)),
                      );
                    },
                    child: Container(
                      height: 35,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/loading.gif',
                          image: widget.user_profile != "Empty"
                              ? widget.user_profile
                              : "https://i.stack.imgur.com/y9DpT.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: widget.user_name,
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.DarkBlueColour,
                          textalign: TextAlign.start),
                      // CustomTextWidget(
                      //     text: 'Bangladesh',
                      //     fontsize: 0.02,
                      //     isbold: false,
                      //     color: CustomColors.ButtonColour,
                      //     textalign: TextAlign.start),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          if (widget.post_content != "Empty")
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomTextWidget(
                      text: widget.post_content,
                      fontsize: 0.025,
                      isbold: false,
                      color: Colors.black,
                      textalign: TextAlign.start),
                ],
              ),
            ),
          SizedBox(
            height: 5,
          ),
          if (widget.post_photo != "Empty")
            Container(
              height: widget.size.height * 0.4,
              width: widget.size.width * 0.95,
              child: Image.network(
                widget.post_photo,
                fit: BoxFit.cover,
              ),
            ),
          Row(
            children: [
              commentlikeshareWidget(
                  icon: Icons.favorite_border,
                  value: widget.post_likes,
                  post_id: widget.post_id,
                  user_id: widget.user_id,
                  text: "like"),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: commentlikeshareWidget(
                    icon: Icons.textsms,
                    value: widget.post_comments,
                    post_id: widget.post_id,
                    user_id: widget.user_id,
                    text: "comment"),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: commentlikeshareWidget(
                    icon: Icons.create,
                    value: widget.post_comments,
                    post_id: widget.post_id,
                    user_id: widget.user_id,
                    text: "do"),
              ),
              SizedBox(
                width: 10,
              ),
              // commentlikeshareWidget(
              //   icon: Icons.share,
              //   value: '34',
              // )
            ],
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class commentlikeshareWidget extends StatelessWidget {
  commentlikeshareWidget({
    required this.icon,
    required this.value,
    required this.post_id,
    required this.user_id,
    required this.text,
    Key? key,
  }) : super(key: key);
  final IconData icon;
  final String value, post_id, user_id, text;

  Future Like(String user_id, String post_id) async {
    var url = Uri.parse(base_url + "post_like.php");
    var response = await http.post(url,
        body: {"user_id": user_id, "post_id": post_id, "auth_key": auth_key});
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Liked");
    } else if (code == "0") {
      ShowResponse("Error Occured");
    }
  }

  Future DoComment(String user_id, String post_id, String comment_content) async {
    var url = Uri.parse(base_url + "post_comment.php");
    var response = await http.post(url,
        body: {"user_id": user_id, "post_id": post_id, "comment_content": comment_content, "auth_key": auth_key});
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Commented");
    } else if (code == "0") {
      ShowResponse("Error Occured");
    }
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
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                if (text == "comment") {
                  var route = new MaterialPageRoute(
                      builder: (BuildContext context) =>
                          new Comments(post_id: post_id));
                  Navigator.of(context).push(route);
                } else if (text == "like") {
                  Like(user_id, post_id);
                } else {
                  CreateAlertDialog(context, user_id, post_id);
                }
              },
              icon: Icon(
                icon,
                size: 30,
              )),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: CustomTextWidget(
                text: value,
                fontsize: 0.02,
                isbold: false,
                color: CustomColors.BlackColour,
                textalign: TextAlign.center),
          )
        ],
      ),
    );
  }

  CreateAlertDialog(BuildContext context, String user_id, String post_id) {
    TextEditingController room_name_controller = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Write Comment"),
            content: TextField(
              keyboardType: TextInputType.text,
              controller: room_name_controller,
            ),
            actions: [
                MaterialButton(
                elevation: 5.0,
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                  //SendEmail(email);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Continue"),
                onPressed: () {
                  DoComment(user_id, post_id, room_name_controller.text);
                   Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

}

class Items {
  final String post_id;
  final String post_content;
  final String post_photo;
  final String code;
  Items(this.post_id, this.post_content, this.post_photo, this.code);
}
