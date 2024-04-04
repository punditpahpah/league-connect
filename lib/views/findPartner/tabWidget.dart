import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';

class tapWidget extends StatelessWidget {
  tapWidget({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: CustomColors.DarkBlue,
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 5,
          ),
          CustomTextWidget(
            color: CustomColors.WhiteColour,
            fontsize: 0.018,
            isbold: true,
            text: text,
            textalign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
