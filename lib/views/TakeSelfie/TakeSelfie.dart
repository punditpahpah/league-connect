import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/home/index.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/SmallButtonWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakeSelfie extends StatefulWidget {
  const TakeSelfie({Key? key}) : super(key: key);

  @override
  _TakeSelfieState createState() => _TakeSelfieState();
}

class _TakeSelfieState extends State<TakeSelfie> {
  String RightText="Skip";
  File? image;

  Future getimg() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    setState(() {
      image = File(img.path);
    });

    ShowResponse(user_id);

    if (image != null) {
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Please wait...');
      await dialog.show();
      final uri = Uri.parse(base_url + "update_profile_img.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = user_id;
      request.fields['type'] = "profile";
      request.fields['auth_key'] = auth_key;
      if (image == null) {
        return;
      }
      var pic = await http.MultipartFile.fromPath("image", File(img.path).path);
      request.files.add(pic);

      var response = await request.send().then((result) async {
        http.Response.fromStream(result).then((response) {
          if (response.body == "uploaded") {
            dialog.hide();
            ShowResponse("Profile updated");
            setState(() {});
          } else if (response.body == "not uploaded") {
            dialog.hide();
            ShowResponse("not uploaded");
          } else {
            dialog.hide();
            ShowResponse(response.body);
          }
          // image = null;
          setState(() {
            RightText="Next";
          });
        });
      });
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
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        decoration: GradientbackgroundColour(),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.HOME);
                  },
                  child: CustomTextWidget(
                      text: RightText,
                      fontsize: 0.025,
                      isbold: false,
                      color: CustomColors.WhiteColour,
                      textalign: TextAlign.center),
                )
              ],
            ),
            Expanded(
                child: Center(
                    child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.07,
                      vertical: size.width * 0.15),
                  padding: EdgeInsets.all(size.height * 0.04),
                  height: size.height * 0.36,
                  //width: size.width*0.7,
                  decoration: BoxDecoration(
                      color: CustomColors.WhiteColour,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        CustomTextWidget(
                            text: 'Upload profile picture',
                            fontsize: 0.022,
                            isbold: true,
                            color: CustomColors.BlackColour,
                            textalign: TextAlign.center),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextWidget(
                            text:
                                'Show us how you look and get more chances to meet people!',
                            fontsize: 0.02,
                            isbold: true,
                            color: CustomColors.BlackColour.withOpacity(0.5),
                            textalign: TextAlign.center),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: (){
                            getimg();
                          },
                          child: SmalllButtonWidget(
                            fontsize: 0.02,
                            height: 0.07,
                            width: 0.4,
                            text: 'TAKE PHOTO',
                            size: size,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        
                      },
                      child: Container(
                        height: size.height * 0.15,
                        width: size.width * 0.27,
                        decoration: BoxDecoration(
                            color: CustomColors.WhiteColour,
                            shape: BoxShape.circle),
                        child: Container(
                          margin: EdgeInsets.all(size.height * 0.012),
                          height: size.height * 0.15,
                          width: size.width * 0.27,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 40.0,
                            child: CircleAvatar(
                              radius: 38.0,
                              child: ClipOval(
                                child: (image != null)
                                    ? Image.file(image!)
                                    : Image.asset('assets/images/default_avatar.png'),
                                    
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )))
          ],
        ),
      ),
    );
  }
}
