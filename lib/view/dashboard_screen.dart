import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nimbus/controller/home_controller.dart';
import 'package:nimbus/view/profile_screen.dart';

import '../constants/app_colors.dart';
import '../model/user_model.dart';
import 'favourites_screen.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.user});

  final User user;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  HomeController homeController = Get.put(HomeController());
  int currIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    _screens.addAll([HomeScreen(user: widget.user), const FavouritesScreen(), const ProfileScreen()]);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[currIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currIndex,
        onTap: (value) {
          currIndex = value;
          setState(() {});
        },
        selectedItemColor: AppColors.LoginScreenIconBg,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            label: "Explore",
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), label: "Favorites"),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person_2_outlined,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
