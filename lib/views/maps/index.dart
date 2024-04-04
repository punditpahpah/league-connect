import 'dart:convert';

import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/payments/payments.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/SmallButtonWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MapsScreen extends StatefulWidget {
  MapsScreen({Key? key}) : super(key: key);
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  var status;

  var text = "Subscribe Now for more filters and premium benefits";

  bool btn_v = true, coun_c = false;

  final CountryController = TextEditingController();

  Future GetProfileData() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "check_subscription.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    status = data[0]['status'];
    await dialog.hide();
    if (status == "0") {
      CreateAlertDialog(context);
    } else {
      coun_c = true;
      btn_v = false;
      text = "Select any country for more matches";
    }
    setState(() {});
  }

  Future Subscribe() async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var ProfilePhoto = await http.get(Uri.parse(base_url +
        "do_subscription.php?user_id=" +
        user_id +
        "&auth_key=" +
        auth_key));

    var data = json.decode(ProfilePhoto.body);

    var code = data[0]['code'];
    await dialog.hide();

    if (code == "1") {
      Navigator.pop(context);
      coun_c = true;
      btn_v = false;
      text = "Select any country for more matches";
    }
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

  CreateAlertDialog(BuildContext context) {
    TextEditingController room_name_controller = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
                "You donot have premium membership.\nFeatures are below\n\n1: Unlimited Likes a day\n2: Incognito Mode\n3: Find matches around the world"),
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
                child: Text("Buy Now"),
                onPressed: () async {
                  // Buy(user_id, post_id, room_name_controller.text);
                  final RouteResponse = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Payments(),
                    ),
                  );
                  if ("$RouteResponse" == "Nope.") {
                    Fluttertoast.showToast(
                        msg: "PayPal Transaction done",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Subscribe();
                  } else if ("$RouteResponse" == "Done.") {
                    Fluttertoast.showToast(
                        msg: "Paypal Transaction done",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    //Add_coins();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.DarkBlueColour,
        elevation: 0,
        title: CustomTextWidget(
          text: 'Filter',
          color: CustomColors.WhiteColour,
          fontsize: 0.03,
          isbold: true,
          textalign: TextAlign.center,
        ),
      ),
      body: Container(
        height: size.height,
        padding: EdgeInsets.all(30),
        decoration: GradientbackgroundColour(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                  text: text,
                  fontsize: 0.025,
                  isbold: true,
                  color: CustomColors.WhiteColour,
                  textalign: TextAlign.start),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: coun_c,
                child: DropDownField(
                  controller: CountryController,
                  strict: true,
                  enabled: true,
                  labelText: 'Select Country',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  icon: Icon(Icons.person, color: Colors.white),
                  items: countryList,
                  setter: (dynamic newValue) {
                    CountryController.text = newValue;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: btn_v,
                child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      final RouteResponse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Payments(),
                        ),
                      );
                      if ("$RouteResponse" == "Nope.") {
                        Fluttertoast.showToast(
                            msg: "PayPal Transaction done",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Subscribe();
                      } else if ("$RouteResponse" == "Done.") {
                        Fluttertoast.showToast(
                            msg: "Paypal Transaction done",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        //Add_coins();
                      }
                    },
                    child: SmalllButtonWidget(
                      size: size,
                      fontsize: 0.02,
                      height: 0.065,
                      text: 'Subscribe Now',
                      width: 0.32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> countryList = [
  "Afghanistan",
  "Albania",
  "Algeria",
  "Andorra",
  "Angola",
  "Anguilla",
  "Antigua &amp; Barbuda",
  "Argentina",
  "Armenia",
  "Aruba",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bermuda",
  "Bhutan",
  "Bolivia",
  "Bosnia &amp; Herzegovina",
  "Botswana",
  "Brazil",
  "British Virgin Islands",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cambodia",
  "Cameroon",
  "Cape Verde",
  "Cayman Islands",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Congo",
  "Cook Islands",
  "Costa Rica",
  "Cote D Ivoire",
  "Croatia",
  "Cruise Ship",
  "Cuba",
  "Cyprus",
  "Czech Republic",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Estonia",
  "Ethiopia",
  "Falkland Islands",
  "Faroe Islands",
  "Fiji",
  "Finland",
  "France",
  "French Polynesia",
  "French West Indies",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Gibraltar",
  "Greece",
  "Greenland",
  "Grenada",
  "Guam",
  "Guatemala",
  "Guernsey",
  "Guinea",
  "Guinea Bissau",
  "Guyana",
  "Haiti",
  "Honduras",
  "Hong Kong",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Isle of Man",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jersey",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kuwait",
  "Kyrgyz Republic",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Macau",
  "Macedonia",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Montserrat",
  "Morocco",
  "Mozambique",
  "Namibia",
  "Nepal",
  "Netherlands",
  "Netherlands Antilles",
  "New Caledonia",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Norway",
  "Oman",
  "Pakistan",
  "Palestine",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Poland",
  "Portugal",
  "Puerto Rico",
  "Qatar",
  "Reunion",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Pierre &amp; Miquelon",
  "Samoa",
  "San Marino",
  "Satellite",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Slovakia",
  "Slovenia",
  "South Africa",
  "South Korea",
  "Spain",
  "Sri Lanka",
  "St Kitts &amp; Nevis",
  "St Lucia",
  "St Vincent",
  "St. Lucia",
  "Sudan",
  "Suriname",
  "Swaziland",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor L'Este",
  "Togo",
  "Tonga",
  "Trinidad &amp; Tobago",
  "Tunisia",
  "Turkey",
  "Turkmenistan",
  "Turks &amp; Caicos",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "Uruguay",
  "Uzbekistan",
  "Venezuela",
  "Vietnam",
  "Virgin Islands (US)",
  "Yemen",
  "Zambia",
  "Zimbabwe"
];
