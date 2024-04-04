import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/home/Social/header.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CardWidget.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class FindLove extends StatefulWidget {
  FindLove({Key? key}) : super(key: key);
  @override
  _FindLoveState createState() => _FindLoveState();
}

class _FindLoveState extends State<FindLove> {
  late AnimationController _controller;
  late Animation<double> _animation;

  String user_location = "";
  String pick_location = "Pick Your Location";
  Future GetProfileData() async {
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "get_profile_data.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    user_location = data[0]['user_location'];
    setState(() {});
  }

  Future<List<Items>> GetPhotos() async {
    var url = Uri.parse(
        base_url + "get_users.php?user_id=$user_id&auth_key=" + auth_key);
    var Photos = await http.get(url);
    var JsonData = json.decode(Photos.body);
    final List<Items> rows = [];
    //nechy jb future builder wala functions jo hoga listview m os m if snapshot.freindship_status=="accpted" then text would Friends
    // if snapshot.following_status=="1" then text would be Following
    for (var u in JsonData) {
      Items item = Items(
          u["user_id"],
          u["user_name"],
          u["user_about"],
          u["user_age"],
          u["user_profile"],
          u["height"],
          u["life_style"],
          u["star_name"],
          u["drinking"],
          u["looking_for"],
          u["education"],
          u["smoking"],
          u["kids"],
          u["location"],
          u["second_photo"],
          u["code"]);
      rows.add(item);
    }
    return rows;
  }

  GetLocation() async {
    setState(() {
      pick_location = "Updating";
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude}');
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    var loc = first.addressLine;
    var country = first.countryName;
    // ShowResponse("${first.addressLine}");
    UpdateLocation(loc.toString(), position.latitude.toString(),
        position.longitude.toString(), country.toString());
  }

  UpdateLocation(String Location, String Latitude, String Longitude,
      String Country) async {
    var url = Uri.parse(base_url + "update_location.php");
    var response = await http.post(url, body: {
      "user_id": user_id,
      "location": Location,
      "latitude": Latitude,
      "longitude": Longitude,
      "country": Country,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Location Updated");
      setState(() {
        user_location = Location;
      });
    } else if (code == "0") {
      ShowResponse("Location Not Updated");
    } else {
      ShowResponse(response.body.toString());
    }

    // Get.toNamed(AppRoutes.TAKESELFIE);
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
    setState(() {
      GetProfileData();
    });
  }

  @override
  void initState() {
    getStringValuesSF();

    super.initState();
  }

  Future Action(String opposite_id, String Action) async {
    var url = Uri.parse(base_url + "profile_likes_dislikes.php");
    var response = await http.post(url, body: {
      "user_id": user_id,
      "opposite_id": opposite_id,
      "action": Action,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
    } else if (code == "0") {
      ShowResponse("Error Occured");
    }
  }

  int total_cards = 0;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    List<String> _images = [
      "assets/images/user.jpg",
      "assets/images/user.jpg",
      "assets/images/user.jpg",
      "assets/images/user.jpg",
      "assets/images/user.jpg",
      "assets/images/user.jpg",
    ];
    CardController cardController = new CardController();
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: GradientbackgroundColour(),
        child: Container(
          child: Column(
            children: [
              header(),
              if (user_location == "Empty")
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      GetLocation();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomTextWidget(
                            text: '$pick_location ',
                            fontsize: 0.02,
                            isbold: true,
                            color: Colors.white,
                            textalign: TextAlign.start),
                        Icon(Icons.gps_fixed, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              if (show)
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CustomTextWidget(
                        text: 'No More matches. Refresh Now',
                        fontsize: 0.03,
                        isbold: true,
                        color: Colors.white,
                        textalign: TextAlign.start),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            show = false;
                          });
                        },
                        child:
                            Icon(Icons.refresh, color: Colors.white, size: 50)),
                  ],
                ),
              Expanded(
                flex: 10,
                child: FutureBuilder(
                  future: GetPhotos(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: CustomTextWidget(
                              text: "Finding People Around You...",
                              fontsize: 0.03,
                              isbold: true,
                              color: Colors.white,
                              textalign: TextAlign.start),
                        ),
                      );
                    } else if (snapshot.data[0].code == "0") {
                      return Container(
                        child: Center(
                          child: CustomTextWidget(
                              text: "No People Found",
                              fontsize: 0.03,
                              isbold: true,
                              color: Colors.white,
                              textalign: TextAlign.start),
                        ),
                      );
                    } else {
                      total_cards = snapshot.data.length;
                      return Container(
                        child: TinderSwapCard(
                          cardController: cardController,
                          allowVerticalMovement: false,
                          totalNum: snapshot.data.length,
                          stackNum: 3,
                          maxWidth: size.width * 0.95,
                          maxHeight: size.height * 0.8,
                          minWidth: size.width * 0.9,
                          minHeight: size.height * 0.75,
                          cardBuilder: (context, index) {
                            return cardWidget(
                                my_id: user_id,
                                user_id: snapshot.data[index].user_id,
                                user_name: snapshot.data[index].user_name,
                                user_age: snapshot.data[index].user_age,
                                user_about: snapshot.data[index].user_about,
                                size: size,
                                image: "assets/images/user.jpg",
                                cardController: cardController,
                                height: snapshot.data[index].height,
                                life_style: snapshot.data[index].life_style,
                                star_name: snapshot.data[index].star_name,
                                drinking: snapshot.data[index].drinking,
                                looking_for: snapshot.data[index].looking_for,
                                education: snapshot.data[index].education,
                                smoking: snapshot.data[index].smoking,
                                kids: snapshot.data[index].kids,
                                location: snapshot.data[index].location,
                                second: snapshot.data[index].second_photo);
                          },
                          swipeCompleteCallback:
                              (CardSwipeOrientation orientation, int index) {
                            if (orientation == CardSwipeOrientation.LEFT) {
                              Action(snapshot.data[index].user_id, "0");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('Disliked'),
                                  duration: Duration(milliseconds: 2000),
                                ),
                              );

                              if (index == total_cards - 1) {
                                setState(() {
                                  show = true;
                                });
                              }
                            } else if (orientation ==
                                CardSwipeOrientation.RIGHT) {
                              Action(snapshot.data[index].user_id, "1");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text('Liked'),
                                  duration: Duration(milliseconds: 2000),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Items {
  final String user_id;
  final String user_name;
  final String user_about;
  final String user_age;
  final String user_profile;
  final String height;
  final String life_style;
  final String star_name;
  final String drinking;
  final String looking_for;
  final String education;
  final String smoking;
  final String kids;
  final String location;
  final String second_photo;
  final String code;
  Items(
      this.user_id,
      this.user_name,
      this.user_about,
      this.user_age,
      this.user_profile,
      this.height,
      this.life_style,
      this.star_name,
      this.drinking,
      this.looking_for,
      this.education,
      this.smoking,
      this.kids,
      this.location,
      this.second_photo,
      this.code);
}
