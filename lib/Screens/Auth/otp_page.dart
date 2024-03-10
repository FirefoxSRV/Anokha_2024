import 'dart:convert';

import 'package:anokha/Screens/Auth/login_page.dart';
import 'package:anokha/Screens/Auth/register_page.dart';
import 'package:anokha/constants.dart';
import 'package:anokha/utils/helper/helper_function.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class RegisterOtpScreen extends StatefulWidget {
  const RegisterOtpScreen({super.key});

  @override
  State<RegisterOtpScreen> createState() => _RegisterOtpScreenState();
}

class _RegisterOtpScreenState extends State<RegisterOtpScreen>
    with TickerProviderStateMixin {
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  String? otpCode;
  String? otpToken;

  late AnimationController _controller;
  late Animation gradientAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    gradientAnimation = ColorTween(
      begin: const Color(0xFF082c44),
      end: const Color(0xFF3a5e76),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _otpValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP!';
    } else if (value.length != 6) {
      return 'Please enter a valid 6 digit OTP!';
    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Invalid OTP';
    }
    return null;
  }

  Future<String> _verifyOtpAndLogin() async {
    final dio = Dio();
    otpToken = await HelperFunctions.getOTPTokenKeyFromSF();
    var bytes = utf8.encode(otpCode!);
    var digest = sha256.convert(bytes);
    String hashedOTP = digest.toString();

    try {
      final response = await dio.post(
        Constants.verify,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $otpToken",
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ),
        data: {
          "otp": hashedOTP,
        },
      );
      if (kDebugMode) {
        print('hashed otp :$hashedOTP');
      }
      if (kDebugMode) {
        print("[LOGIN]: ${response.data}");
        print("[STATUS]: ${response.statusCode}");
      }
      if (response.statusCode == 200) {
        return "1";
      } else if (response.data["MESSAGE"] != null) {
        showToast(response.data["MESSAGE"]);
        return "0";
      } else if (response.statusCode == 401) {
        showToast("Unauthorized action");
        return "0";
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          print(response);
        }
        showToast("Something went wrong. Please try again later!");
      } else {
        showToast("Something went wrong. Please try again later!");
        return "0";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showToast("Something went wrong. Please try again later!");
    }

    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(43, 30, 56, 1),
                    Color.fromRGBO(11, 38, 59, 1),
                    Color.fromRGBO(15, 21, 39, 1),
                  ],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar.large(
                    floating: false,
                    backgroundColor: Colors.transparent,
                    pinned: true,
                    snap: false,
                    expandedHeight: MediaQuery.of(context).size.height * 0.2,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                            (route) => false);
                      },
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      collapseMode: CollapseMode.parallax,
                      title: Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.1),
                        child: Text(
                          "OTP Verification",
                          style: GoogleFonts.quicksand(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 48,
                            ),
                            Text(
                              "Submit OTP",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(children: [
                                const SizedBox(
                                  height: 16,
                                ),
                                Pinput(
                                  controller: _otpController,
                                  validator: _otpValidator,
                                  length: 6,
                                  defaultPinTheme: PinTheme(
                                    width: 56,
                                    height: 56,
                                    textStyle: GoogleFonts.quicksand(
                                        fontSize: 22, color: Colors.white),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      otpCode = value;
                                    });
                                  },
                                  onCompleted: (value) {
                                    setState(() {
                                      otpCode = value;
                                    });
                                  },
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => isLoading = true);

                                      var value = await _verifyOtpAndLogin();

                                      // showDelightfulToast(
                                      //   context,
                                      //   value == "1"
                                      //       ? "OTP verified successfully."
                                      //       : value == "-1"
                                      //       ? "OTP expired. Please try again."
                                      //       : "",
                                      //   value == "1",
                                      // );
                                      if (value == "1") {
                                        showToast("OTP verified successfully");

                                        Navigator.pop(context);
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const LoginReg();
                                        }));
                                      } else {
                                        // Navigator.pop(context);
                                        showToast('OTP went wrong');
                                      }
                                      // Navigator.pushAndRemoveUntil(
                                      //     context, MaterialPageRoute(builder: (context) => value == "1"
                                      //     ? const PrimaryScreen()
                                      //     : const RegisterPage(),),(route)=>false);

                                      setState(() => isLoading = false);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFF082c44),
                                    backgroundColor: Colors.white, // Text color
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: Text(
                                    "Verify",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
