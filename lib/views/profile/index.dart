import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/EditProfile/photo_preview.dart';
import 'package:dating_app/widgets/ButtonWidget.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dating_app/widgets/SmallButtonWidget.dart';

class Profile extends StatefulWidget {
  String user_id;
  Profile({required this.user_id, Key? key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user_profile = "https://i.stack.imgur.com/y9DpT.jpg";
  String user_name = "";
  String user_about = "";
  String user_age = "";
  String champion1 = "";
  String champion2 = "";
  String champion3 = "";
  String region1 = "";
  String region2 = "";
  String region3 = "";
  var f_user;
  Future GetProfileData(String user_id) async {
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "get_user_data.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    user_name = data[0]['user_name'];
    user_age = data[0]['user_age'];
    if (user_age != "Empty") {
      user_name += ", " + user_age;
    }
    user_about = data[0]['user_about'];
    user_profile = data[0]['user_profile'];
    champion1 = data[0]['champion1'];
    champion2 = data[0]['champion2'];
    champion3 = data[0]['champion3'];
    region1 = data[0]['region1'];
    region2 = data[0]['region2'];
    region3 = data[0]['region3'];
    setState(() {});
  }

  var user_id;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {
      if(user_id==widget.user_id){
      
      setState(() {
        from="me";
        f_user=user_id;
        GetProfileData(user_id);
      });
    }
    else{
      
      setState(() {
        SendNoti(user_id, widget.user_id, "viewed your profile");
        from="no";
        f_user=widget.user_id;
        GetProfileData(widget.user_id);
      });
    }  
    });

    
    
  }

  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(
        base_url + "get_all_photos.php?user_id=$f_user&auth_key=" + auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(u["photo_url"], u["code"]);
      rows.add(item);
    }
    return rows;
  }

  File? image;

  Future getimg() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img == null) {
      return;
    }

    setState(() {
      image = File(img.path);
    });

    if (image != null) {
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Please wait...');
      await dialog.show();
      final uri = Uri.parse(base_url + "update_profile_img.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = user_id;
      request.fields['type'] = "gallery";
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
            ShowResponse("Uploaded");
            setState(() {
              GetPhotos();
            });
            setState(() {});
          } else if (response.body == "not uploaded") {
            dialog.hide();
            ShowResponse("Not Uploaded");
          } else {
            dialog.hide();
            ShowResponse(response.body);
          }
          // image = null;
        });
      });
    }
  }

  Message() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(base_url + "send_greetings.php");
    var response = await http.post(url, body: {
      "my_id": user_id,
      "opponent_id": widget.user_id,
      "message": "Hello their",
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    
    if (code == "1") {
      await dialog.hide();

      ShowResponse("Message Sent");

    } else if (code == "0") {
      ShowResponse("Message Not Sent");
    } else {
      ShowResponse(response.body.toString());
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

  String from="";

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  Future SendNoti(String my_id, String opponent_id, String message) async {
    var url = Uri.parse(base_url + "send_noti.php");
    var response = await http.post(url,
        body: {"my_id": my_id, "opponent_id": opponent_id, "message": message, "auth_key": auth_key});
    // var data = json.decode(response.body);
    // var code = data[0]['code'];
    // if (code == "1") {
    //   ShowResponse("Commented");
    // } else if (code == "0") {
    //   ShowResponse("Error Occured");
    // }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  color:
                                      CustomColors.WhiteColour.withOpacity(0.5),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new PhotoPreview(
                                    from: from,
                                    edit: "yes",
                                    link: "no",
                                  ));
                          Navigator.of(context).push(route);
                        },
                        child: Container(
                          height: 100,
                          width: 100,
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
                      SizedBox(height: 20),
                      if (from == "me")
                        GestureDetector(
                          onTap: () {
                            getimg();
                          },
                          child: SmalllButtonWidget(
                            size: size,
                            fontsize: 0.02,
                            height: 0.060,
                            text: 'ADD PHOTOS',
                            width: 0.32,
                          ),
                        ),
                      Expanded(flex: 1, child: Container()),
                      if (from != "me")
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.35,
                                  height: size.height * 0.07,
                                  decoration: BoxDecoration(
                                    color: CustomColors.DarkBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                  ),
                                  child: Center(
                                    child: GestureDetector(
                                      onTap:(){
                                        Message();
                                      },
                                      child: CustomTextWidget(
                                        text: 'Message',
                                        color: CustomColors.WhiteColour,
                                        fontsize: 0.02,
                                        isbold: true,
                                        textalign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                )),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: CustomColors.WhiteColour,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * 0.10),
                      topRight: Radius.circular(size.width * 0.10)),
                ),
                child: ListView(
                  children: [
                    CustomTextWidget(
                        text: user_name,
                        fontsize: 0.03,
                        isbold: true,
                        color: CustomColors.DarkBlueColour,
                        textalign: TextAlign.center),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Champion One",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Champion Two",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Champion Three",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: champion1,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: champion2,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: champion3,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Region One",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Region Two",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: "Region Three",
                                fontsize: 0.025,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: region1,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: region2,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: CustomTextWidget(
                                text: region3,
                                fontsize: 0.02,
                                isbold: true,
                                color: CustomColors.DarkBlueColour,
                                textalign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: CustomTextWidget(
                          text: user_about,
                          fontsize: 0.03,
                          isbold: false,
                          color: CustomColors.DarkBlueColour,
                          textalign: TextAlign.center),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: FutureBuilder(
                        future: GetPhotos(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: CustomTextWidget(
                                    text: "Loading...",
                                    fontsize: 0.03,
                                    isbold: true,
                                    color: Colors.black,
                                    textalign: TextAlign.start),
                              ),
                            );
                          } else if (snapshot.data[0].code == "0") {
                            return Container(
                              child: Center(
                                child: CustomTextWidget(
                                    text: "No Photos",
                                    fontsize: 0.03,
                                    isbold: true,
                                    color: Colors.white,
                                    textalign: TextAlign.start),
                              ),
                            );
                          } else {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 15.0,
                                  ),
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    {
                                      return GestureDetector(
                                        onTap: () {
                                          var route = new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new PhotoPreview(
                                                    from: from,
                                                    edit: "no",
                                                    link: snapshot
                                                        .data[index].photo_url,
                                                  ));
                                          Navigator.of(context).push(route);
                                        },
                                        child: Container(
                                            margin: EdgeInsets.all(5),
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data[index].photo_url),
                                                  fit: BoxFit.cover),
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                            )),
                                      );
                                    }
                                  }),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Items {
  final String photo_url;
  final String code;
  Items(this.photo_url, this.code);
}

// GridView.builder(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent: 200,
//                 childAspectRatio: 3 / 2,
//                 crossAxisSpacing: 20,
//                 mainAxisSpacing: 20),
//             itemCount: myProducts.length,
//             itemBuilder: (BuildContext ctx, index) {
//               return Container(
//                 alignment: Alignment.center,
//                 child: Text(myProducts[index]["name"]),
//                 decoration: BoxDecoration(
//                     color: Colors.amber,
//                     borderRadius: BorderRadius.circular(15)),
//               );
//             }),
