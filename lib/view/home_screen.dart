import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nimbus/controller/home_controller.dart';
import 'package:nimbus/widget/region_card_shimmer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../model/user_model.dart';
import '../utils/app_model.dart';
import '../widget/city_card_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});

  final User user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  double _scrollThreshold = 150;

  // %
  @override
  void initState() {
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.extentAfter <= _scrollThreshold && homeController.hasNext) {
        homeController.getAllCities();
      }
    });
    // TODO: implement initState
    super.initState();
  }

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
        color: AppColors.loginScreenFieldHint,
      ),
      filled: true,
      fillColor: AppColors.splashScreenPrimaryText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: border,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: AppColors.loginScreenIconBg, width: 1.5),
      ),
      prefixIcon: prefixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeScreenBg,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 30,
        children: [
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () {
              // _scrollController.jumpTo(0);
              _scrollController.animateTo(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.bounceIn,
              );
            },
            child: Icon(Icons.arrow_upward),
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            },
            child: Icon(Icons.arrow_downward),
          ),
        ],
      ),
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
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.loginScreenSecondaryText,
                        ),
                      ),
                      Text(
                        widget.user.user!.name!,
                        style: GoogleFonts.sora(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.loginScreenPrimaryText,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.loginScreenIconBg,
                    child: Text(
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      widget.user.user!.name!.trim().split(' ').map((l) => l[0]).join().toUpperCase(),
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _searchController,
                decoration: _fieldDecoration(
                  "Search cities or countries",
                  prefixIcon: Icon(Icons.search),
                ),
              ),

              Obx(() {
                final selected = homeController.selectedRegionIndex.value;
                return homeController.isRegionLoading.value
                    ? const RegionShimmer()
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < homeController.regions.length; i++)
                              GestureDetector(
                                onTap: () => homeController.changeRegion(i),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 9,
                                  ),
                                  margin: const EdgeInsets.only(
                                    left: 15,
                                    top: 14,
                                    bottom: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: i == selected ? AppColors.loginScreenIconBg : AppColors.splashScreenPrimaryText,
                                    borderRadius: BorderRadius.circular(99),
                                    border: Border.all(
                                      color: i == selected ? Colors.blue : AppColors.sideBorderColor,
                                    ),
                                  ),
                                  child: Text(
                                    homeController.regions[i],
                                    style: TextStyle(
                                      color: i == selected ? AppColors.splashScreenPrimaryText : null,
                                    ),
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
                    style: GoogleFonts.sora(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: AppColors.loginScreenPrimaryText,
                    ),
                  ),
                  Obx(
                    () => Text(
                      homeController.isCitiesCountLoading.value ? 'Loading....' : "${homeController.citiesCount} results",
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: AppColors.loginScreenSecondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),

              GetBuilder<HomeController>(
                builder: (c) => Expanded(
                  child: Builder(
                    builder: (context) {
                      // JumpTo, animateTo, extentAfter,
                      // Initial loading shimmer
                      if (c.citiesWeather.isEmpty && c.isCitiesLoading) {
                        return ListView.builder(
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const CityCardShimmer();
                          },
                        );
                      }

                      if (c.citiesWeather.isEmpty && !c.isCitiesLoading) {
                        return const Center(
                          child: Text("No cities found"),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: c.citiesWeather.length + (c.isCitiesLoading ? 1 : 0),

                        // itemCount: c.citiesWeather.length,
                        itemBuilder: (context, index) {
                          if (index == c.citiesWeather.length) {
                            if (c.isCitiesLoading) {
                              return const CityCardShimmer();
                            }
                            // return SizedBox(
                            //   width: double.infinity,
                            //   child: ElevatedButton(
                            //     onPressed: c.isCitiesLoading
                            //         ? null
                            //         : () {
                            //             c.getCities();
                            //           },
                            //     child: const Text("Show more"),
                            //   ),
                            // );
                          }

                          final city = c.citiesWeather[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: appModel.getWeatherIconBg(
                                      appModel.getWeatherEnum(
                                        city.weather!.condition!.icon!,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Image.asset(
                                    appModel.getWeatherIcon(
                                      appModel.getWeatherEnum(
                                        city.weather!.condition!.icon!,
                                      ),
                                    ),
                                    height: 28,
                                    width: 28,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city.name!,
                                        style: GoogleFonts.sora(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: AppColors.loginScreenPrimaryText,
                                        ),
                                      ),

                                      const SizedBox(height: 2),

                                      Text(
                                        "${city.country!} · ${city.region!}",
                                        style: GoogleFonts.dmSans(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: AppColors.loginScreenSecondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 4),

                                Text(
                                  "${city.weather!.temperatureC!.toStringAsFixed(0)}°",
                                  style: GoogleFonts.sora(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 22,
                                    color: AppColors.loginScreenPrimaryText,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
