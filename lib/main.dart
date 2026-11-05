import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus/constants/app_routes.dart';
import 'package:nimbus/controller/auth_controller.dart';
import 'package:nimbus/utils/app_model.dart';
import 'package:nimbus/view/dashboard_screen.dart';
import 'package:nimbus/view/home_screen.dart';
import 'package:nimbus/view/login_screen.dart';
import 'package:nimbus/view/signup_screen.dart';
import 'package:nimbus/view/splash_screen.dart';

void main() {
  AppModel appModel = Get.put(AppModel(), permanent: true);
  Get.put(AuthController());
  appModel.initPref();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: AppRoutes.splashRoute,
          page: () => SplashScreen(),
          transition: Transition.fadeIn,
        ),

        GetPage(
          name: AppRoutes.loginRoute,
          page: () => LoginScreen(),
          transition: Transition.fadeIn,
        ),

        GetPage(
          name: AppRoutes.registerRoute,
          page: () => SignupScreen(),
          transition: Transition.rightToLeft,
        ),

        GetPage(
          name: AppRoutes.bottomNavRoute,
          page: () {
            final argument = Get.arguments;
            return DashboardScreen(user: argument['user']);
          },
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}
