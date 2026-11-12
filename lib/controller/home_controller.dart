import 'dart:async';
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

  // Flutter framework debounce
  Timer? searchTimer;

  // Getx debounce
  RxString searchText = "".obs;
  Worker? searchWorker;

  @override
  void onInit() {
    searchWorker = debounce(searchText, (value) async {
      print("CHANGING VALUE IN WOKRER $value");
      await getAllCities(reset: true);
    }, time: Duration(milliseconds: 1000));
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    getRegions();
    getAllCities();
    // TODO: implement onReady
    super.onReady();
  }

  // searchQuery(String value) async {
  //   searchText.value = value;
  //   searchTimer?.cancel();
  //   searchTimer = Timer(Duration(milliseconds: 1000), () async {
  //     await getAllCities(reset: true);
  //   });
  // }

  getAllCities({bool reset = false}) async {
    Map<String, String> queryParams = {};

    if (reset) {
      hasNext = true;
      cityPage = 1;
      citiesWeather.clear();
      update();
    }

    if (isCitiesLoading || !hasNext) return;

    isCitiesLoading = true;
    isCitiesCountLoading.value = true;
    update();

    try {
      queryParams = {
        'limit': '8',
        'page': '$cityPage',
      };

      if (searchText.isNotEmpty) {
        queryParams.addAll(
          {'search': searchText.value},
        );
      }
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
      isCitiesCountLoading.value = false;
      update();
    }
  }

  void changeRegion(int index) {
    if (selectedRegionIndex.value == index) return;
    selectedRegionIndex.value = index;
    getAllCities(reset: true);
  }

  getRegions() async {
    isRegionLoading.value = true;
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
    }
  }
}
