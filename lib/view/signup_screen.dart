import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import '../controller/auth_controller.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool loading = false;

  AuthController authController = Get.isRegistered<AuthController>() ? Get.find<AuthController>() : Get.put(AuthController());

  Future<void> Signup() async {
    setState(() => loading = true);
    if (_nameController.text.length < 2 || _passwordController.text.length < 8 || !(_emailController.text.contains('@'))) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Fill the fields correctly"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Uri url = Uri.parse(ApiConstants.signupApi);
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      if (response.statusCode == 201) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration Completed'),
            backgroundColor: Colors.lightGreen,
          ),
        );
        var route = Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Network error. Try again...'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint, {Widget? suffixIcon}) {
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
        borderSide: const BorderSide(color: AppColors.LoginScreenIconBg, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: AppColors.LoginScreenSecondaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.LoginScreenBg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: AppColors.LoginScreenIconBg,
                          ),
                          child: const Icon(
                            Icons.wb_sunny_outlined,
                            color: AppColors.SplashScreenPrimaryText,
                            size: 30,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            authController.obscurePassword.value = true;
                            Future.delayed(Duration(milliseconds: 300), () {
                              _emailController.clear();
                              _passwordController.clear();
                              _nameController.clear();
                            });
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: AppColors.LoginScreenIconBg,
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_left,
                              color: AppColors.SplashScreenPrimaryText,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Heading
                    Text(
                      "Create your account",
                      style: GoogleFonts.sora(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        letterSpacing: -0.5,
                        color: AppColors.LoginScreenPrimaryText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Save cities and notes, and sync them on every device.",
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                        color: AppColors.LoginScreenSecondaryText,
                      ),
                    ),
                    const SizedBox(height: 32),

                    _label("Full name"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration("John Doe"),
                    ),
                    const SizedBox(height: 18),

                    // Email
                    _label("Email"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _fieldDecoration("you@example.com"),
                    ),
                    const SizedBox(height: 18),

                    // Password
                    _label("Password"),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        controller: _passwordController,
                        obscureText: authController.obscurePassword.value,
                        decoration: _fieldDecoration(
                          "Enter your password",
                          suffixIcon: IconButton(
                            onPressed: authController.changeObscure,
                            icon: Icon(
                              authController.obscurePassword.value ? Icons.remove_red_eye_outlined : Icons.visibility_off_outlined,
                              color: AppColors.LoginScreenSecondaryText,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Log in button (full width)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "All fields are required",
                              colorText: Colors.red,
                              snackPosition: SnackPosition.TOP,
                            );
                          } else {
                            authController.signup(email: _emailController.text, password: _passwordController.text, name: _nameController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.LoginScreenIconBg,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Obx(
                          () => authController.isLoading.value
                              ? Row(
                                  spacing: 12,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: AppColors.SplashScreenPrimaryText.withValues(alpha: 0.25),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          AppColors.SplashScreenPrimaryText,
                                        ),
                                      ),
                                    ),
                                    const Text("Signing up..", style: TextStyle(color: AppColors.SplashScreenPrimaryText, fontSize: 18)),
                                  ],
                                )
                              : Text(
                                  "Create account",
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.SplashScreenPrimaryText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              color: AppColors.LoginScreenSecondaryText,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              var route = Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Log in",
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.LoginScreenIconBg,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
