import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:dating_app/widgets/ButtonWidget.dart';
import 'package:dating_app/widgets/CustomTextWidget.dart';
import 'package:dating_app/widgets/backgroundcolour.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        decoration: GradientbackgroundColour(),
        child: Column(
          children: [
            Expanded(flex: 4, child: Container(
              child: Hero(
                tag: 'logo',
                child: Image.asset('assets/images/logo.png',
                width: size.width*0.75,
                ),
              ),
            )),
            Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      ButtonWidget(size: size, text: "Male"),
                      ButtonWidget(
                        size: size,
                        text: "Female",
                      ),
                      ButtonWidget(
                        size: size,
                        text: "Others",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.SIGNIN);
                          },
                          child: CustomTextWidget(
                            text: 'Sign In',
                            fontsize: 0.03,
                            isbold: true,
                            color: CustomColors.ButtonColour,
                            textalign: TextAlign.center
                          ),
                        ),
                      ),
                      CustomTextWidget(
                          textalign: TextAlign.center,
                          text:
                              'Your social media pages will be looked at to provide conformation of League Connect Status',
                          fontsize: 0.02,
                          isbold: true,
                          color: CustomColors.BlackColour),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
