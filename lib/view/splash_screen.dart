import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nimbus/constants/app_routes.dart';
import 'package:nimbus/controller/auth_controller.dart';

import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import '../controller/api_controller.dart';
import '../model/user_model.dart';

import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SplashScreenBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nimbus",
              style: GoogleFonts.sora(fontWeight: FontWeight.w800, fontSize: 44, color: AppColors.SplashScreenPrimaryText),
            ),
            Text(
              "Weather & city guide",
              style: GoogleFonts.dmSans(color: AppColors.SplashScreensSecondaryText, fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Checking your session...",
              style: GoogleFonts.dmMono(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.SplashScreensSessionText),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              if (controller.isLoading.value) {
                // Loading State
                return CircularProgressIndicator(
                  strokeWidth: 4,
                  backgroundColor: AppColors.SplashScreenPrimaryText.withValues(alpha: 0.25),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.SplashScreenPrimaryText,
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty) {
                // Error State
                return Column(
                  children: [
                    Text(
                      controller.errorMessage.value,
                      style: GoogleFonts.dmSans(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: () {
                        controller.statusCheck();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
