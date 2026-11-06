import 'dart:convert';

import 'package:get/get.dart';
import 'package:nimbus/constants/api_constants.dart';
import 'package:nimbus/controller/api_controller.dart';

import '../model/cities_model.dart';
import '../model/ciy_model.dart';

class HomeController extends GetxController {
  RxList<dynamic> regions = [].obs;
  List<City> citiesWeather = [];
  RxInt selectedRegionIndex = 0.obs;
  RxInt citiesCount = 0.obs;
  RxBool isRegionLoading = false.obs;
  RxBool isCitiesCountLoading = false.obs;

  @override
  void onReady() {
    print("On Ready Called");
    getRegions();
    getCities();
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onInit() {
    print("On Init Called");
    // TODO: implement onInit
    super.onInit();
  }

  void changeRegion(int index) {
    if (selectedRegionIndex.value == index) return;
    selectedRegionIndex.value = index;
  }

  getRegions() async {
    isRegionLoading.value = true;
    isCitiesCountLoading.value = true;
    var response = await ApiController().get(url: ApiConstants.regionApi);
    if (response.$1 == 200 || response.$1 == 201) {
      regions.add('All');
      var regionResponse = jsonDecode(response.$2);
      var listOfRegion = regionResponse['data'];
      for (var region in listOfRegion) {
        citiesCount = citiesCount + region['count'];
        regions.add(region['name']);
      }
      // double doubleValue = 23.45453;
      // print("ROUND OFF ===> ${doubleValue.toStringAsFixed(0)}");
      isRegionLoading.value = false;
      isCitiesCountLoading.value = false;
    }
  }

  getCities({int page = 1}) async {
    var response = await ApiController().get(url: ApiConstants.citiesApi(page: page));
    if (response.$1 == 200 || response.$1 == 201) {
      final cities = citiesFromJson(response.$2);
      if (cities.data != null) {
        citiesWeather.addAll(cities.data!);
        update();
      }
    }
  }
}
