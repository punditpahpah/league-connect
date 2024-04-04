import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/SmallButtonWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final CaptionController = TextEditingController();

  String btn_text = "Upload Photo";

  File? image;

  var img;

  Future getimg() async {
    img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    setState(() {
      image = File(img.path);
      btn_text = "Uploaded";
    });
  }

  var user_id;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
  }

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future DoPost(String Caption) async {
    // if (image != null) {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    final uri = Uri.parse(base_url + "do_post.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = user_id;
    request.fields['caption'] = Caption;
    request.fields['type'] = "post";
    request.fields['auth_key'] = auth_key;
    if (image != null) {
      var pic = await http.MultipartFile.fromPath("image", File(img.path).path);
      request.files.add(pic);
    }

    var response = await request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.body == "uploaded") {
          dialog.hide();
          ShowResponse("Post Published");

          setState(() {
            btn_text="Upload Photo";
            CaptionController.text="";
          });
        } else if (response.body == "not uploaded") {
          dialog.hide();
          ShowResponse("Post Not Published");
        } else {
          dialog.hide();
          ShowResponse(response.body);
        }
        if (image != null) {
          image = null;
        }
        // image = null;
      });
    });
    //}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.DarkBlueColour,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextWidget(
                text: 'Create Post',
                fontsize: 0.03,
                isbold: true,
                color: CustomColors.WhiteColour,
                textalign: TextAlign.start),
            GestureDetector(
              onTap: () {
                DoPost(CaptionController.text);
              },
              child: CustomTextWidget(
                  text: 'Post',
                  fontsize: 0.025,
                  isbold: false,
                  color: CustomColors.WhiteColour,
                  textalign: TextAlign.start),
            ),
          ],
        ),
        // actions: [

        // ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        height: size.height * 1,
        width: size.width * 1,
        decoration: GradientbackgroundColour(),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: size.width * 0.15,
                    height: size.height * 0.15,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/user.jpg')),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CustomTextWidget(
                      text: 'Nisaa',
                      fontsize: 0.025,
                      isbold: true,
                      color: CustomColors.WhiteColour,
                      textalign: TextAlign.start),
                ],
              ),
            ),
            Expanded(
                flex: 10,
                child: Column(
                  children: [
                    // Container(
                    //   width: size.width * 1,
                    //   height: size.height * 0.4,
                    //   child: Image.asset(
                    //     'assets/images/user.jpg',
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: CaptionController,
                      textInputAction: TextInputAction.newline,
                      // keyboardType: TextInputType.multiline,
                      minLines: 2,
                      maxLines: 3, //
                      cursorColor: Colors.white,
                      style: TextStyle(
                          color: CustomColors.WhiteColour, fontSize: 18),
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          labelText: 'Say Something',
                          labelStyle: TextStyle(
                              color: CustomColors.WhiteColour, fontSize: 18)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          getimg();
                        },
                        child: SmalllButtonWidget(
                            fontsize: 0.025,
                            height: 0.06,
                            text: btn_text,
                            width: 0.85,
                            size: size))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
