import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';

class FriendRequest extends StatelessWidget {
  const FriendRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Container(
                            child: CustomTextWidget(
                              color: CustomColors.WhiteColour,
                              fontsize: 0.025,
                              isbold: true,
                              text: 'Follow Requests',
                              textalign: TextAlign.start,
                            ),
                          )),
                      Expanded(flex: 2, child: Container()),
                    ],
                  ),
                )),
            Expanded(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: ListView(
                    children: [
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                      UserRequest(image: 'assets/images/user.jpg',mainText: 'Simon',text: 'Follow Me'),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class UserRequest extends StatelessWidget {
  UserRequest({
    required this.image,
    required this.mainText,
    required this.text,
    Key? key,
  }) : super(key: key);
  String text, mainText, image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => SingleUserChat()),
          //   );
        },
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        image,
                      )),
                  color: CustomColors.WhiteColour,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 4,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: mainText,
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: text,
                          fontsize: 0.02,
                          isbold: false,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start)
                    ],
                  ),
                )),
            Expanded(
              flex: 2,
              child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: CustomColors.DarkBlue
              ),
              child: CustomTextWidget(color: CustomColors.WhiteColour,fontsize: 0.02,isbold: true,text: 'Confirm',textalign: TextAlign.center,),
            ),
            )
          ],
        ),
      ),
    );
  }
}
