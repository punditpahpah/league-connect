import 'package:dating_app/routes/app_pages.dart';
import 'package:dating_app/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dating App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(color: CustomColors.ButtonColour),
        fontFamily: 'Nunito',
        primaryColor: CustomColors.ButtonColour,
      ),
       getPages: AppPages.routes,
      //unknownRoute: AppPages.unknownRoute,
      initialRoute: AppRoutes.SPLASH_SCREEN,
    );
  }
}
