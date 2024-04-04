import 'package:dating_app/theme/colors.dart';
import 'package:flutter/material.dart';

import 'CustomTextWidget.dart';


class SmalllButtonWidget extends StatelessWidget {
  SmalllButtonWidget({
    required this.fontsize,
    required this.height,
    required this.text,
    required this.width,
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  final String text;
  double height, width, fontsize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * height,
      width: size.width * width,
      decoration: BoxDecoration(
          color: CustomColors.ButtonColour,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
          child: CustomTextWidget(
        color: CustomColors.WhiteColour,
        fontsize: fontsize,
        isbold: true,
        text: text,
        textalign: TextAlign.center,
      )),
    );
  }
}
