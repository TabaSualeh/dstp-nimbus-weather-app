import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../model/city_model.dart';
import '../utils/app_model.dart';

class CityDetailScreen extends StatefulWidget {
  CityDetailScreen({required this.data, super.key});

  City data;

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  AppModel appModel = Get.find<AppModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final forecast = [
      {'day': 'Tue', 'icon': AppAssets.yellowSunIcon, 'temp': '29°'},
      {'day': 'Wed', 'icon': AppAssets.cloudSunIcon, 'temp': '30°'},
      {'day': 'Thu', 'icon': AppAssets.yellowSunIcon, 'temp': '31°'},
      {'day': 'Fri', 'icon': AppAssets.cloudIcon, 'temp': '28°'},
      {'day': 'Sat', 'icon': AppAssets.cloudRainIcon, 'temp': '26°'},
    ];

    final activities = [
      {'icon': Icons.wb_sunny_outlined, 'title': 'Clifton Beach', 'category': 'Beach'},
      {'icon': Icons.account_balance_outlined, 'title': 'Mohatta Palace', 'category': 'Museum'},
      {'icon': Icons.account_balance_outlined, 'title': 'Quaid-e-Azam Mausoleum', 'category': 'Landmark'},
    ];

    return Scaffold(
      backgroundColor: AppColors.homeScreenBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadowColor,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Get.back();
                        },
                        child: const SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.arrow_back,
                            size: 22,
                            color: AppColors.loginScreenPrimaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadowColor,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          print('FAVORITE');
                        },
                        child: const SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            Icons.favorite_border,
                            size: 22,
                            color: AppColors.loginScreenPrimaryText,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Main weather card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: appModel.getWeatherIconColor(
                    appModel.getWeatherEnum(
                      widget.data.weather!.condition!.icon!,
                    ),
                  ),
                  // gradient: const LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     AppColors.heroGradientStart,
                  //     AppColors.heroGradientEnd,
                  //   ],
                  // ),
                  borderRadius: BorderRadius.circular(28),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Color(0x402F6BFF),
                  //     blurRadius: 28,
                  //     offset: Offset(0, 14),
                  //   ),
                  // ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${widget.data.country} · ${widget.data.region}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.data.name!,
                      style: GoogleFonts.sora(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.data.weather!.temperatureC!.toStringAsFixed(0)}°',
                            style: GoogleFonts.sora(
                              fontSize: 76,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SvgPicture.asset(
                          height: 75,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          appModel.getWeatherIcon(
                            appModel.getWeatherEnum(
                              widget.data.weather!.condition!.icon!,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Partly cloudy · Feels like 29°',
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Humidity, wind and UV information
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadowColor,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.water_drop_outlined,
                                size: 16,
                                color: AppColors.loginScreenIconBg,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'Humidity',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.loginScreenSecondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '64%',
                            style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.loginScreenPrimaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadowColor,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.air,
                                size: 16,
                                color: AppColors.loginScreenIconBg,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'Wind',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.loginScreenSecondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '14 km/h',
                            style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.loginScreenPrimaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadowColor,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.wb_sunny_outlined,
                                size: 16,
                                color: AppColors.loginScreenIconBg,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  'UV index',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.loginScreenSecondaryText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '6',
                            style: GoogleFonts.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.loginScreenPrimaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Five-day forecast
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.cardShadowColor,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '5-day forecast',
                      style: GoogleFonts.sora(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.loginScreenPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        for (final day in forecast)
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  day['day'] as String,
                                  style: GoogleFonts.dmSans(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.loginScreenSecondaryText,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: Image.asset(
                                    day['icon'] as String,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  day['temp'] as String,
                                  style: GoogleFonts.sora(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.loginScreenPrimaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              Text(
                'Things to do',
                style: GoogleFonts.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.loginScreenPrimaryText,
                ),
              ),

              const SizedBox(height: 12),

              // Activity list
              Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadowColor,
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.weatherIconBlueColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              activity['icon'] as IconData,
                              size: 22,
                              color: AppColors.loginScreenIconBg,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              activity['title'] as String,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sora(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.loginScreenPrimaryText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            activity['category'] as String,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.loginScreenSecondaryText,
                            ),
                          ),
                        ],
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
}
