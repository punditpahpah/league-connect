import 'package:dating_app/theme/colors.dart';
import 'package:flutter/material.dart';

BoxDecoration GradientbackgroundColour() {
  return BoxDecoration(
      gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [
      0.15,
      0.35,
      0.7,
      0.95,
    ],
    colors: [
      CustomColors.DarkBlueColour,
      CustomColors.GreenColour,
      CustomColors.DarkBlueColour,
      CustomColors.GreenColour,
    ],
    // tileMode: TileMode.repeated,
  ));
}
