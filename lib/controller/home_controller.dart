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
  bool isCitiesLoading = false;
  int cityPage = 1;

  bool hasNext = true;

  @override
  void onReady() {
    print("On Ready Called");
    getRegions();
    getAllCities();
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
    hasNext = true;
    cityPage = 1;
    citiesWeather.clear();
    getAllCities();
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
        // citiesCount = citiesCount + region['count'];
        regions.add(region['name']);
      }
      isRegionLoading.value = false;
      isCitiesCountLoading.value = false;
    }
  }

  getAllCities() async {
    if (isCitiesLoading || !hasNext) return;

    isCitiesLoading = true;
    update();

    try {
      var queryParams = {
        'limit': '8',
        'page': '$cityPage',
      };
      if (selectedRegionIndex.value != 0) {
        queryParams.addAll({'region': '${regions[selectedRegionIndex.value]}'});
      }
      var response = await ApiController().get(
        url: ApiConstants.citiesApi,
        queryParams: queryParams,
      );

      if (response.$1 == 200 || response.$1 == 201) {
        final cities = citiesFromJson(response.$2);

        hasNext = cities.meta!.hasNext!;
        citiesCount.value = cities.meta!.total!;
        print("CITIES COUNT ${citiesCount.value}");
        if (cities.data != null) {
          citiesWeather.addAll(cities.data!);
        }

        cityPage++;

        update();
      }
    } catch (e) {
      print("Cities API Error: $e");
    } finally {
      isCitiesLoading = false;
      update();
    }
  }
}
