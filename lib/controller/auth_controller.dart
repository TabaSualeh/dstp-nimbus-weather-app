import 'dart:convert';

import 'package:get/get.dart';
import 'package:nimbus/constants/api_constants.dart';
import 'package:nimbus/controller/api_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_routes.dart';
import '../model/user_model.dart';

class AuthController extends GetxController {
  User? userLoggedIn;

  RxBool obscurePassword = true.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    statusCheck();
    // TODO: implement onReady
    super.onReady();
  }

  Future<void> statusCheck() async {
    isLoading.value = true;
    errorMessage.value = '';
    final apiData = await ApiController().get(url: ApiConstants.authApi, isToken: true);

    try {
      if (apiData.$1 == 503) {
        errorMessage.value = 'No Internet Connection';
      } else if (apiData.$1 == 401) {
        Get.offAllNamed(
          AppRoutes.loginRoute,
        );
      } else if (apiData.$1 == 200) {
        User user = userFromJson(apiData.$2);
        Get.offAllNamed(
          AppRoutes.bottomNavRoute,
          arguments: {'user': user},
        );
      } else {
        errorMessage.value = 'Unable to verify your session. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Please try again.';
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void changeObscure() {
    obscurePassword.value = !obscurePassword.value;
  }

  login({required String email, required String password}) async {
    isLoading.value = true;
    var response = await ApiController().post(
      url: ApiConstants.loginApi,
      body: {'email': email, 'password': password},
    );
    print(response.$1);
    if (response.$1 == 200 || response.$1 == 201) {
      userLoggedIn = userFromJson(response.$2);
      print("USER LOGGED IN $userLoggedIn");
      if (userLoggedIn != null) {
        ApiController().setToken(value: userLoggedIn!.token!);
      }
      Get.offAllNamed(
        AppRoutes.bottomNavRoute,
        arguments: {
          "user": userLoggedIn,
        },
      );
    } else if (response.$1 >= 400 || response.$1 <= 499) {
      var jsonResponse = jsonDecode(response.$2);
      print(jsonResponse['error']['message']);
      Get.snackbar(jsonResponse['error']['code'], jsonResponse['error']['message']);
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
    isLoading.value = false;
  }

  signup({required String email, required String password, required String name}) async {
    isLoading.value = true;
    var response = await ApiController().post(
      url: ApiConstants.signupApi,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    print(response.$1);
    print(response.$2);
    if (response.$1 == 200 || response.$1 == 201) {
      // userLoggedIn = userFromJson(response.$2);
      // print("USER LOGGED IN $userLoggedIn");
      // if (userLoggedIn != null) {
      //   ApiController().setToken(value: userLoggedIn!.token!);
      // }
      // Get.offAllNamed(
      //   AppRoutes.bottomNavRoute,
      //   arguments: {
      //     "user": userLoggedIn,
      //   },
      // );
    } else if (response.$1 >= 400 || response.$1 <= 499) {
      // var jsonResponse = jsonDecode(response.$2);
      // print(jsonResponse['error']['message']);
      // Get.snackbar(jsonResponse['error']['code'], jsonResponse['error']['message']);
    } else {
      Get.snackbar("Error", "Something went wrong");
    }
    isLoading.value = false;
  }
}
