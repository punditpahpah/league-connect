import 'dart:async';

import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpenStory extends StatefulWidget {
  const OpenStory({Key? key}) : super(key: key);

  @override
  _OpenStoryState createState() => _OpenStoryState();
}

class _OpenStoryState extends State<OpenStory> {
  double percent = 0.0;
  late Timer timer;
  void starttime() {
    timer = Timer.periodic(Duration(microseconds: 100), (timer) {
      setState(() {
        percent += 0.01;
        if (percent > 100) {
          timer.cancel();
          Navigator.pop(context);
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    starttime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
        child: Container(
      decoration: BoxDecoration(color: CustomColors.ButtonColour),
      child: Stack(
        children: [
          Image.asset('assets/images/user.jpg',
              width: size.width * 1,
              height: size.height * 1,
              fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: LinearProgressIndicator(
              value: percent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.13,
                        height: size.height * 0.13,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/images/user.jpg'))),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CustomTextWidget(
                          text: 'Nisa',
                          fontsize: 0.03,
                          isbold: true,
                          color: CustomColors.WhiteColour,
                          textalign: TextAlign.start)
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      timer.cancel();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: CustomColors.WhiteColour,
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
