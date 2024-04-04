import 'package:chips_choice/chips_choice.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'tabWidget.dart';

class cardWidget extends StatelessWidget {
  cardWidget({
    Key? key,
    required this.my_id,
    required this.user_id,
    required this.user_name,
    required this.user_about,
    required this.user_age,
    required this.image,
    required this.size,
    required this.cardController,
    required this.height,
    required this.life_style,
    required this.star_name,
    required this.drinking,
    required this.looking_for,
    required this.education,
    required this.smoking,
    required this.kids,
    required this.location,
    required this.second
  }) : super(key: key);

  final Size size;
  String image,
      my_id,
      user_id,
      user_name,
      user_age,
      user_about,
      height,
      life_style,
      star_name,
      drinking,
      looking_for,
      education,
      smoking,
      kids,
      location,
      second;
  CardController cardController;

  Future Action(String Action) async {
    var url = Uri.parse(base_url + "profile_likes_dislikes.php");
    var response = await http.post(url, body: {
      "user_id": my_id,
      "opposite_id": user_id,
      "action": Action,
      "auth_key": auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
    } else if (code == "0") {
      Fluttertoast.showToast(
          msg: "Error Occured",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: size.width * 0.95,
        height: size.height * 0.8,
        decoration: BoxDecoration(
            color: CustomColors.DarkBlueColour,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    "https://leagueconnect.highoncyber.com/uploads/profiles/image_picker2646527889574526723avatar_31.jpg",
                    fit: BoxFit.cover,
                    height: size.height * 0.75,
                    width: size.width * 0.95,
                  ),
                  Container(
                    height: size.height * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (user_age == "Empty")
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CustomTextWidget(
                                text: user_name,
                                fontsize: 0.035,
                                isbold: true,
                                color: CustomColors.ButtonColour,
                                textalign: TextAlign.start),
                          ),
                        if (user_age != "Empty")
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: CustomTextWidget(
                                text: user_name + " " + user_age,
                                fontsize: 0.035,
                                isbold: true,
                                color: CustomColors.ButtonColour,
                                textalign: TextAlign.start),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: 'About me',
                          fontsize: 0.03,
                          isbold: true,
                          color: CustomColors.ButtonColour,
                          textalign: TextAlign.start),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextWidget(
                          text: user_about,
                          fontsize: 0.023,
                          isbold: true,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextWidget(
                          text: 'My basic info',
                          fontsize: 0.03,
                          isbold: true,
                          color: CustomColors.ButtonColour,
                          textalign: TextAlign.start),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (height != "Empty")
                            Chip(
                              label: Text(
                                height,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.height,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (life_style != "Empty")
                            Chip(
                              label: Text(
                                life_style,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.living_outlined,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (star_name != "Empty")
                            Chip(
                              label: Text(
                                star_name,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.star,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (drinking != "Empty")
                            Chip(
                              label: Text(
                                drinking,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.local_drink_outlined,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (looking_for != "Empty")
                            Chip(
                              label: Text(
                                looking_for,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.search,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (smoking != "Empty")
                            Chip(
                              label: Text(
                                smoking,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.smoking_rooms,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if (kids != "Empty")
                            Chip(
                              label: Text(
                                kids,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.bedroom_baby_rounded,
                                ),
                              ),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (education != "Empty")
                            Chip(
                              label: Text(
                                education,
                              ),
                              avatar: InkWell(
                                onTap: () {},
                                child: Icon(
                                  Icons.book,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // CustomTextWidget(
                      //     text: 'My Interests',
                      //     fontsize: 0.03,
                      //     isbold: true,
                      //     color: CustomColors.ButtonColour,
                      //     textalign: TextAlign.start),
                      // SizedBox(
                      //   height: 5,
                      // ),
                    ],
                  )),
              SizedBox(
                height: 20,
              ),
              if(second!="Empty")
              Image.network(
                second,
                fit: BoxFit.cover,
                height: size.height * 0.5,
                width: size.width * 0.95,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        CustomTextWidget(
                            text: user_name+' \'s location',
                            fontsize: 0.015,
                            isbold: true,
                            color: CustomColors.WhiteColour,
                            textalign: TextAlign.start),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextWidget(
                        text: location,
                        fontsize: 0.03,
                        isbold: false,
                        color: CustomColors.WhiteColour,
                        textalign: TextAlign.start),
                    // CustomTextWidget(
                    //     text: '9.0 mile away',
                    //     fontsize: 0.03,
                    //     isbold: false,
                    //     color: CustomColors.WhiteColour,
                    //     textalign: TextAlign.start),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.ButtonColour,
                          ),
                          child: IconButton(
                            onPressed: () {
                              
                              cardController.triggerLeft();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 50,
                            ),
                            color: CustomColors.WhiteColour,
                          ),
                        ),
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColors.ButtonColour,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Center(
                                child: Dialog(
                                  child: Icon(
                                    Icons.check,
                                    color: CustomColors.WhiteColour,
                                  ),
                                  backgroundColor: CustomColors.GreenColour,
                                  insetAnimationDuration:
                                      const Duration(milliseconds: 100),
                                ),
                              );
                              
                              cardController.triggerRight();
                            },
                            icon: Icon(
                              Icons.done,
                              size: 50,
                            ),
                            color: CustomColors.WhiteColour,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
