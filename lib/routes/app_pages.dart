import 'package:dating_app/views/TakeSelfie/TakeSelfie.dart';
import 'package:dating_app/views/chat/index.dart';
import 'package:dating_app/views/chat/personChat.dart';
import 'package:dating_app/views/createPost/index.dart';
import 'package:dating_app/views/home/Social/openstory.dart';
import 'package:dating_app/views/home/index.dart';
import 'package:dating_app/views/initialScreen.dart/initialScreen.dart';
import 'package:dating_app/views/login/login/index.dart';
import 'package:dating_app/views/maps/index.dart';
import 'package:dating_app/views/profile/index.dart';
import 'package:dating_app/views/splashScreen/SplashScreen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH_SCREEN, page: () => SplashScreen()),
    GetPage(name: AppRoutes.HOME, page: () => Home()),
    GetPage(name: AppRoutes.CHAT, page: () => chat()),
    GetPage(name: AppRoutes.INITIALSCREEN, page: () => InitialScreen()),
    GetPage(name: AppRoutes.TAKESELFIE, page: () => TakeSelfie()),
     GetPage(name: AppRoutes.SIGNIN, page: () => SignIn()),
     //GetPage(name: AppRoutes.PROFILE, page: () => Profile(from:"from")),
     GetPage(name: AppRoutes.SINGLEUSERCHAT, page: () => SingleUserChat()),
     GetPage(name: AppRoutes.OPENSTORY, page: () => OpenStory()),
     GetPage(name: AppRoutes.CREATEPOST, page: () => CreatePost()),
  ];
}
