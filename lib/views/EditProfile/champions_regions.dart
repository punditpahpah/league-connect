import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/EditProfile/photo_preview.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:dropdownfield/dropdownfield.dart';

class Champ_Reg extends StatefulWidget {
  const Champ_Reg({Key? key}) : super(key: key);

  @override
  _Champ_RegState createState() => _Champ_RegState();
}

class _Champ_RegState extends State<Champ_Reg> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String champion1 = "";
  String champion2 = "";
  String champion3 = "";
  String region1 = "";
  String region2 = "";
  String region3 = "";
  Future GetProfileData() async {
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "get_champ_reg.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    champion1 = data[0]['champion1'];
    champion2 = data[0]['champion2'];
    champion3 = data[0]['champion3'];
    region1 = data[0]['region1'];
    region2 = data[0]['region2'];
    region3= data[0]['region3'];

    Champion1Controller.text = champion1;
    Champion2Controller.text = champion2;
    Champion3Controller.text = champion3;
    Region1Controller.text = region1;
    Region2Controller.text = region2;
    Region3Controller.text = region3;

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

  final Champion1Controller = TextEditingController();
  final Champion2Controller = TextEditingController();
  final Champion3Controller = TextEditingController();
  final Region1Controller = TextEditingController();
  final Region2Controller = TextEditingController();
  final Region3Controller = TextEditingController();

  Login() {
    print("valid");
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      var Champion1 = Champion1Controller.text;
      var Champion2 = Champion2Controller.text;
      var Champion3 = Champion3Controller.text;
      var Region1 = Region1Controller.text;
      var Region2 = Region2Controller.text;
      var Region3 = Region3Controller.text;

      UpdateProfile(Champion1, Champion2, Champion3, Region1, Region2, Region3);
    } else {
      ShowResponse("Please Fill Required Fields");
    }
  }

  UpdateProfile(String Champion1, String Champion2, String Champion3,
      String Region1, String Region2, String Region3) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(base_url + "update_champ_reg.php");
    var response = await http.post(url, body: {
      "user_id": user_id,
      "champion1": Champion1,
      "champion2": Champion2,
      "champion3": Champion3,
      "region1": Region1,
      "region2": Region2,
      "region3": Region3,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];

    if (code == "1") {
      await dialog.hide();

      ShowResponse("Profile Update");
    } else if (code == "0") {
      ShowResponse("Current Passowrd is Wrong");
      await dialog.hide();
    } else {
      ShowResponse(response.body.toString());
      await dialog.hide();
    }
  }

  GetLocation() async {
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: GradientbackgroundColour(),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: CustomTextWidget(
                          color: CustomColors.WhiteColour,
                          fontsize: 0.03,
                          isbold: true,
                          text: 'Champions & Regions',
                          textalign: TextAlign.start,
                        ),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.check,
                            color: CustomColors.WhiteColour,
                          ),
                          onPressed: () {
                            validate();
                          },
                        ),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 12,
                child: Form(
                  key: formkey,
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 10,
                            child: Container(
                              padding: EdgeInsets.all(20),
                               constraints: BoxConstraints.expand(),
                              child: ListView(
                                children: [
                                  TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: Champion1Controller,
                                      decoration: InputDecoration(
                                          hintText: 'Champion One',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: Champion2Controller,
                                      decoration: InputDecoration(
                                          hintText: 'Champion Two',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: Champion3Controller,
                                      decoration: InputDecoration(
                                          hintText: 'Champion 3',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: Region1Controller,
                                    strict: true,
                                    
                                    enabled: true,
                                    labelText: 'Region One',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.map, color: Colors.white),
                                    items: regionList,
                                    setter: (dynamic newValue) {
                                      Region1Controller.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: Region2Controller,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Region Two',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.map, color: Colors.white),
                                    items: regionList,
                                    setter: (dynamic newValue) {
                                      Region2Controller.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: Region3Controller,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Region Three',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.map, color: Colors.white),
                                    items: regionList,
                                    setter: (dynamic newValue) {
                                      Region3Controller.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

List<String> regionList = [
  "Demacia",
  "Freljord",
  "Ionia",
  "Noxus",
  "Piltover and Zaun",
  "The Shadow Isles"
];
