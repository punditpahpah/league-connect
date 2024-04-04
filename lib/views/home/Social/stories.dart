import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';

class storiesWidget extends StatelessWidget {
  const storiesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          circularWidget(),
          circularWidget(),
          circularWidget(),
          circularWidget(),
          circularWidget(),
          circularWidget(),
        ],
      ),
    );
  }
}

class circularWidget extends StatelessWidget {
  const circularWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.all(6),
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: CustomColors.WhiteColour,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CustomColors.LightGreen,
                CustomColors.SkyBlueColour,
              ],
              // tileMode: TileMode.repeated,
            ),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: () {
             Navigator.pushNamed(context, AppRoutes.OPENSTORY);
            },
            child: Container(
                decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/user.jpg',
                  )),
            )),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        CustomTextWidget(
            text: 'nisa',
            fontsize: 0.02,
            isbold: false,
            color: CustomColors.WhiteColour,
            textalign: TextAlign.center)
      ],
    );
  }
}
