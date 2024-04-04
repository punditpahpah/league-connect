import 'dart:convert';

import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/TakeSelfie/TakeSelfie.dart';
import 'package:dating_app/views/login/login/index.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/SmallButtonWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final NameController = TextEditingController();
  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();
  final ReWritePasswordController = TextEditingController();

  Signin(String UserName, String UserEmail, String UserPassword) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(base_url + "register.php");
    var response = await http.post(url, body: {
      "name": UserName,
      "email": UserEmail,
      "password": UserPassword,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      await dialog.hide();
      ShowResponse("Registered Successfully");
      Login(UserEmail, UserPassword);
      // NameController.text="";
      // EmailController.text="";
      // PasswordController.text="";
      // ReWritePasswordController.text="";

      // addStringToSF() async {
      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   prefs.setString('is_logged_in', "yes");
      //   prefs.setString('user_id', data[0]['user_id']);
      //   prefs.setString('user_firstname', data[0]['user_firstname']);
      //   prefs.setString('user_lastname', data[0]['user_lastname']);
      //   prefs.setString('user_avatar', data[0]['user_avatar']);
      //   //prefs.setString('user_lastname', data[0]['user_password']);
      //   prefs.setString('email', data[0]['email']);
      // }

      // addStringToSF();

      // Get.toNamed(
      //   AppRoutes.HOME,
      // );
      // var route = new MaterialPageRoute(
      //     builder: (BuildContext context) => new SocialLogins());
      //Navigator.of(context).push(route);
    } else if (code == "0") {
      ShowResponse("Not Registered");
      await dialog.hide();
    } else {
      ShowResponse(response.body.toString());
      await dialog.hide();
    }

    // Get.toNamed(AppRoutes.TAKESELFIE);
  }

  Login(String UserEmail, String UserPassword) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(base_url + "login.php");
    var response = await http.post(url, body: {
      "email": UserEmail,
      "password": UserPassword,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];

    if (code == "1") {
      await dialog.hide();
      addStringToSF() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('is_logged_in', "yes");
        prefs.setString('user_id', data[0]['user_id']);
      }

      addStringToSF();

      ShowResponse("Logged In Successfully");

      var route = new MaterialPageRoute(
          builder: (BuildContext context) => new TakeSelfie());
      Navigator.of(context).push(route);
    } else if (code == "0") {
      ShowResponse("Invalid Credentials");
      await dialog.hide();
    } else {
      ShowResponse(response.body.toString());
      await dialog.hide();
    }
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      var UserName = NameController.text;
      var UserEmail = EmailController.text;
      var UserPassword = PasswordController.text;
      var RewritePassword = ReWritePasswordController.text;
      if (UserPassword != RewritePassword) {
        ShowResponse("Password Does Not Match");
      } else {
        Signin(UserName, UserEmail, UserPassword);
      }
    } else {
      ShowResponse("Please Enter All Info");
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: GradientbackgroundColour(),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios))
                    ],
                  ),
                )),
            Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                  child: Form(
                    autovalidate: true,
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomTextWidget(
                                  text: 'Sign Up',
                                  fontsize: 0.04,
                                  isbold: true,
                                  color: CustomColors.ButtonColour,
                                  textalign: TextAlign.start),
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.08,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                        text: 'Full Name',
                                        fontsize: 0.025,
                                        isbold: false,
                                        color: CustomColors.BlackColour,
                                        textalign: TextAlign.start),
                                  ],
                                ),
                                TextFormField(
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                        text: 'Email',
                                        fontsize: 0.025,
                                        isbold: false,
                                        color: CustomColors.BlackColour,
                                        textalign: TextAlign.start),
                                  ],
                                ),
                                TextFormField(
                                  controller: EmailController,
                                  validator: MultiValidator([
                                    RequiredValidator(errorText: "Required"),
                                    EmailValidator(
                                        errorText: "Not A Valid Email")
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                        text: 'Password',
                                        fontsize: 0.025,
                                        isbold: false,
                                        color: CustomColors.BlackColour,
                                        textalign: TextAlign.start),
                                  ],
                                ),
                                TextFormField(
                                  controller: PasswordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    } else if (value.length < 4) {
                                      return "Password Should Be At Least 4 Characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextWidget(
                                        text: 'ReWrite Password',
                                        fontsize: 0.025,
                                        isbold: false,
                                        color: CustomColors.BlackColour,
                                        textalign: TextAlign.start),
                                  ],
                                ),
                                TextFormField(
                                  controller: ReWritePasswordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Required";
                                    } else if (value.length < 4) {
                                      return "Password Should Be At Least 4 Characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  validate();
                                },
                                child: SmalllButtonWidget(
                                  size: size,
                                  fontsize: 0.02,
                                  height: 0.065,
                                  text: 'SIGN UP',
                                  width: 0.32,
                                ),
                              )
                            ],
                          )

                          // ListView(
                          //   children: [
                          //     TextFormField(
                          //       decoration: InputDecoration(

                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  ),
                )),
            Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.12),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              child: CustomTextWidget(
                                color: CustomColors.BlackColour,
                                fontsize: 0.02,
                                isbold: false,
                                text: 'Already Registered? Login here',
                                textalign: TextAlign.start,
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: CustomTextWidget(
                              color: CustomColors.BlackColour,
                              fontsize: 0.02,
                              isbold: false,
                              text: 'Forget Password?',
                              textalign: TextAlign.end,
                            ),
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
