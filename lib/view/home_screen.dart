import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nimbus/controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../model/user_model.dart';
import '../utils/app_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();

  HomeController homeController = Get.find<HomeController>();
  AppModel appModel = Get.find<AppModel>();

  InputDecoration _fieldDecoration(String hint, {Widget? prefixIcon}) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.fieldBorderColor),
    );
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.LoginScreenFieldHint,
      ),
      filled: true,
      fillColor: AppColors.SplashScreenPrimaryText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: AppColors.LoginScreenIconBg, width: 1.5),
      ),
      prefixIcon: prefixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.HomeScreenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appModel.getGreeting(),
                        style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.LoginScreenSecondaryText),
                      ),
                      Text(
                        widget.user.user!.name!,
                        style: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.LoginScreenPrimaryText),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.LoginScreenIconBg,
                    child: Text(
                      style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                      widget.user.user!.name!.trim().split(' ').map((l) => l[0]).join().toUpperCase(),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _searchController,
                decoration: _fieldDecoration("Search cities or countries", prefixIcon: Icon(Icons.search)),
              ),

              Obx(() {
                final selected = homeController.selectedRegionIndex.value;
                return homeController.isRegionLoading.value
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Shimmer.fromColors(
                          period: Duration(milliseconds: 1000),
                          // Colors.grey.shade300
                          // Colors.grey.shade100
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade200,
                          child: Row(
                            children: [
                              regionChipShimmer(),
                              regionChipShimmer(),
                              regionChipShimmer(),
                              regionChipShimmer(),
                              regionChipShimmer(),
                              regionChipShimmer(),
                              regionChipShimmer(),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < homeController.regions.length; i++)
                              GestureDetector(
                                onTap: () => homeController.changeRegion(i),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                  margin: const EdgeInsets.only(left: 15, top: 14, bottom: 14),
                                  decoration: BoxDecoration(
                                    color: i == selected ? AppColors.LoginScreenIconBg : AppColors.SplashScreenPrimaryText,
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(
                                      color: i == selected ? Colors.blue : AppColors.sideBorderColor,
                                    ),
                                  ),
                                  child: Text(
                                    homeController.regions[i],
                                    style: TextStyle(color: i == selected ? AppColors.SplashScreenPrimaryText : null),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cities",
                    style: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.LoginScreenPrimaryText),
                  ),
                  Obx(
                    () => Text(
                      homeController.isCitiesCountLoading.value ? 'Loading....' : "${homeController.citiesCount} results",
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w400, fontSize: 13, color: AppColors.LoginScreenSecondaryText),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: homeController.citiesWeather.length,
                  itemBuilder: (context, index) {
                    final citiesWeather = homeController.citiesWeather[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.SplashScreenPrimaryText,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget regionChipShimmer([double horizontalPadding = 30]) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 14),
      margin: const EdgeInsets.only(left: 15, top: 14, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: AppColors.sideBorderColor,
        ),
      ),
    );
  }
}
