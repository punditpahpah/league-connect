import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';

class SingleUserChat extends StatelessWidget {
  const SingleUserChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.WhiteColour,
        leading: IconButton(
          color: CustomColors.ButtonColour,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextWidget(
                  text: 'Alice',
                  fontsize: 0.025,
                  isbold: true,
                  color: CustomColors.BlackColour,
                  textalign: TextAlign.start),
              CustomTextWidget(
                  text: 'Online Now',
                  fontsize: 0.02,
                  isbold: true,
                  color: CustomColors.DarkBlue,
                  textalign: TextAlign.start)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          //header(),
          Expanded(
              flex: 10,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [RightchatMsg(), leftChatMsg()],
                  ),
                ),
              )),

          // SizedBox(
          //   height: 10,
          // )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(5),
        //height: size.height * 0.045,
        width: size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColors.DarkBlue,
              CustomColors.LightGreen,
            ],
          ),
        ),
        child: TextField(
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null, //
          cursorColor: Colors.white,
          style: TextStyle(color: CustomColors.WhiteColour, fontSize: 18),
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              labelText: 'Message....',
              labelStyle:
                  TextStyle(color: CustomColors.WhiteColour, fontSize: 18)),
        ),
      ),
    );
  }
}

class leftChatMsg extends StatelessWidget {
  const leftChatMsg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CustomColors.DarkBlueColour,
                  CustomColors.LightGreen,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          child: CustomTextWidget(
            color: CustomColors.WhiteColour,
            fontsize: 0.025,
            isbold: false,
            text: 'Hye fine nd How are you',
            textalign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class RightchatMsg extends StatelessWidget {
  const RightchatMsg({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CustomColors.DarkBlueColour,
                  CustomColors.GreenColour,
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )),
          child: CustomTextWidget(
            color: CustomColors.WhiteColour,
            fontsize: 0.025,
            isbold: false,
            text: 'Hye How are you',
            textalign: TextAlign.center,
          ),
        )
      ],
    );
  }
}

class header extends StatelessWidget {
  const header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )),
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage(
                          'assets/images/user.jpg',
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
                //padding: const EdgeInsets.only(top:10.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                          text: 'Alice',
                          fontsize: 0.025,
                          isbold: true,
                          color: CustomColors.BlackColour,
                          textalign: TextAlign.start),
                      CustomTextWidget(
                          text: 'Online Now',
                          fontsize: 0.02,
                          isbold: true,
                          color: CustomColors.DarkBlue,
                          textalign: TextAlign.start)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
