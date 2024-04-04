import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/EditProfile/champions_regions.dart';
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

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String user_profile = "https://i.stack.imgur.com/y9DpT.jpg";
  String user_email = "";
  String user_real_name = "";
  String user_ingame_name = "";
  String user_about = "";
  String user_age = "";
  String user_gender = "";
  String user_height = "";
  String user_life_style = "";
  String user_star_name = "";
  String user_drinking = "";
  String user_looking_for = "";
  String user_education = "";
  String user_smoking = "";
  String user_kids = "";
  Future GetProfileData() async {
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "get_profile_data.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    user_email = data[0]['user_email'];
    user_real_name = data[0]['user_real_name'];
    user_ingame_name = data[0]['user_ingame_name'];
    user_about = data[0]['user_about'];
    user_age = data[0]['user_age'];
    user_gender = data[0]['user_gender'];
    user_profile = data[0]['user_profile'];
    user_height = data[0]['user_height'];
    user_life_style = data[0]['user_life_style'];
    user_star_name = data[0]['user_star_name'];
    user_drinking = data[0]['user_drinking'];
    user_looking_for = data[0]['user_looking_for'];
    user_education = data[0]['user_education'];
    user_smoking = data[0]['user_smoking'];
    user_kids = data[0]['user_kids'];

    EmailController.text = user_email;
    NameController.text = user_real_name;
    InGameNameController.text = user_ingame_name;
    BioController.text = user_about;
    AgeController.text = user_age;
    GenderController.text = user_gender;
    HeightController.text = user_height;
    LifeStyleController.text = user_life_style;
    StarController.text = user_star_name;
    DrinkingController.text = user_drinking;
    LookingForController.text = user_looking_for;
    EducationController.text = user_education;
    SmokingController.text = user_smoking;
    KidsController.text = user_kids;

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

  final EmailController = TextEditingController();
  final CurrentPasswordController = TextEditingController();
  final PasswordController = TextEditingController();
  final CPasswordController = TextEditingController();
  final NameController = TextEditingController();
  final InGameNameController = TextEditingController();
  final GenderController = TextEditingController();

  final BioController = TextEditingController();
  final AgeController = TextEditingController();

  final HeightController = TextEditingController();
  final LifeStyleController = TextEditingController();
  final StarController = TextEditingController();
  final DrinkingController = TextEditingController();
  final LookingForController = TextEditingController();
  final EducationController = TextEditingController();
  final SmokingController = TextEditingController();
  final KidsController = TextEditingController();

  Login() {
    print("valid");
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      var RealName = NameController.text;
      var CurrentPassword = CurrentPasswordController.text;
      var NewPass = PasswordController.text;
      var CNewPass = CPasswordController.text;
      var InGameName = InGameNameController.text;
      var Age = AgeController.text;
      var Bio = BioController.text;
      var Gender = GenderController.text;
      var Height = HeightController.text;
      var LifeStyle = LifeStyleController.text;
      var StarName = StarController.text;
      var Drinking = DrinkingController.text;
      var LookingFor = LookingForController.text;
      var Education = EducationController.text;
      var Smoking = SmokingController.text;
      var Kids = KidsController.text;
      UpdateProfile(
          RealName,
          CurrentPassword,
          NewPass,
          CNewPass,
          InGameName,
          Age,
          Bio,
          Gender,
          Height,
          LifeStyle,
          StarName,
          Drinking,
          LookingFor,
          Education,
          Smoking,
          Kids);
    } else {
      ShowResponse("Please Fill Required Fields");
    }
  }

  UpdateProfile(
      String RealName,
      String CurrentPassword,
      String NewPass,
      String CNewPass,
      String InGameName,
      String Age,
      String Bio,
      String Gender,
      String Height,
      String LifeStyle,
      String StarName,
      String Drinking,
      String LookingFor,
      String Education,
      String Smoking,
      String Kids) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(base_url + "update_profile.php");
    var response = await http.post(url, body: {
      "user_id": user_id,
      "email": user_email,
      "real_name": RealName,
      "current_pass": CurrentPassword,
      "new_pass": NewPass,
      "in_game_name": InGameName,
      "age": Age,
      "bio": Bio,
      "gender": Gender,
      "height": Height,
      "life_style": LifeStyle,
      "star_name": StarName,
      "drinking": Drinking,
      "looking_for": LookingFor,
      "education": Education,
      "smoking": Smoking,
      "kids": Kids,
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
                          text: 'Edit Profile',
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
                            var NewPass = PasswordController.text;
                            var CNewPass = CPasswordController.text;
                            if (NewPass == "") {
                              validate();
                            } else if (NewPass != "") {
                              if (NewPass.length < 4) {
                                ShowResponse(
                                    "Password Must Be Atleast 4 Characters long");
                              } else if (NewPass != CNewPass) {
                                ShowResponse("New Password Does Not Match");
                              } else if (NewPass == CNewPass) {
                                validate();
                              }
                            }
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
                          flex: 2,
                          child: GestureDetector(
                            onTap: () {
                              var route = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new PhotoPreview(from: "me", edit: "yes", link: "no"));
                              Navigator.of(context).push(route);
                            },
                            child: Container(
                              height: 50,
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
                        ),
                        Expanded(
                            flex: 10,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: ListView(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      GetLocation();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomTextWidget(
                                            text: "Update Location ",
                                            fontsize: 0.02,
                                            isbold: true,
                                            color: Colors.white,
                                            textalign: TextAlign.start),
                                        Icon(Icons.gps_fixed,
                                            color: Colors.white, size: 20),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      var route = new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Champ_Reg());
                                      Navigator.of(context).push(route);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomTextWidget(
                                            text: "Choose Champions & Regions",
                                            fontsize: 0.02,
                                            isbold: true,
                                            color: Colors.white,
                                            textalign: TextAlign.start),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: EmailController,
                                      enabled: false,
                                      decoration: InputDecoration(
                                          hintText: 'Email',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.name,
                                      controller: NameController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        } else if (value.length < 3) {
                                          return "Name Should Be At Least 3 Characters";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Name',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      controller: CurrentPasswordController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        } else {
                                          return null;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Current Password',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: PasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: 'New Password',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: CPasswordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          hintText: 'Confirm New Password',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      controller: InGameNameController,
                                      decoration: InputDecoration(
                                          hintText: 'In Game Name',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: AgeController,
                                      decoration: InputDecoration(
                                          hintText: 'Age',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  TextFormField(
                                      controller: BioController,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                          hintText: 'Bio',
                                          hintStyle: TextStyle(
                                            color: CustomColors.WhiteColour,
                                          ))),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: GenderController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Gender',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon:
                                        Icon(Icons.person, color: Colors.white),
                                    items: genderList,
                                    setter: (dynamic newValue) {
                                      GenderController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: HeightController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Height',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon:
                                        Icon(Icons.height, color: Colors.white),
                                    items: heightList,
                                    setter: (dynamic newValue) {
                                      HeightController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: LifeStyleController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Life Style',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.living_outlined,
                                        color: Colors.white),
                                    items: lifeStyleList,
                                    setter: (dynamic newValue) {
                                      LifeStyleController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: StarController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Star Name',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.star, color: Colors.white),
                                    items: starList,
                                    setter: (dynamic newValue) {
                                      StarController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: DrinkingController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Drinking',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.select_all),
                                    items: drinkingList,
                                    setter: (dynamic newValue) {
                                      DrinkingController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: LookingForController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Looking For',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.select_all,
                                        color: Colors.white),
                                    items: lookingForList,
                                    setter: (dynamic newValue) {
                                      LookingForController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: EducationController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Education',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.book, color: Colors.white),
                                    items: educationList,
                                    setter: (dynamic newValue) {
                                      EducationController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: SmokingController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Smoking',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.smoking_rooms,
                                        color: Colors.white),
                                    items: smokingList,
                                    setter: (dynamic newValue) {
                                      SmokingController.text = newValue;
                                    },
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  DropDownField(
                                    controller: KidsController,
                                    strict: true,
                                    enabled: true,
                                    labelText: 'Kids',
                                    labelStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                    icon: Icon(Icons.bedroom_baby,
                                        color: Colors.white),
                                    items: kidsList,
                                    setter: (dynamic newValue) {
                                      KidsController.text = newValue;
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

List<String> genderList = ["Male", "Female"];
List<String> heightList = [
  "5 ft",
  "5.1 ft",
  "5.2 ft",
  "5.3 ft",
  "5.4 ft",
  "5.5 ft"
];
List<String> lifeStyleList = ["Sedentary", "Normal", "Active"];
List<String> starList = ["Sirius", "Canopus"];
List<String> drinkingList = ["Casually", "Regularly"];
List<String> lookingForList = ["Something Casuall", "Serious"];
List<String> educationList = ["Matriculation", "Intermidiate"];
List<String> smokingList = ["Less", "More"];
List<String> kidsList = ["No kids", "Want kinds"];
