import 'dart:convert';

import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/views/login/signUp/index.dart';
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

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final EmailController = TextEditingController();
  final PasswordController = TextEditingController();

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

      Navigator.pushNamed(context, AppRoutes.HOME);

    } else if (code == "0") {
      ShowResponse("Invalid Credentials");
    } else {
      ShowResponse(response.body.toString());
    }
    
  }

  void validate() {
    if (formkey.currentState!.validate()) {
      var UserEmail = EmailController.text;
      var UserPassword = PasswordController.text;

      Login(UserEmail,UserPassword);
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
    return Material(
      child: Container(
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
                          }, icon: Icon(Icons.arrow_back_ios))
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
                                  text: 'Sign In',
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
                                        text: 'Username/Email',
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
                                      return "required";
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
                                    text: 'SIGN IN',
                                    width: 0.32,
                                  ))
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
                          child: Container(
                            child: GestureDetector(
                              onTap: () {
                                Get.to(SignUp());
                              },
                              child: CustomTextWidget(
                                color: CustomColors.BlackColour,
                                fontsize: 0.02,
                                isbold: false,
                                text: 'New? SignUp here',
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
