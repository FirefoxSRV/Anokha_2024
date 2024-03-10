import 'dart:convert';
import 'package:anokha/Screens/Auth/primary_page.dart';
import 'package:anokha/constants.dart';
import 'package:anokha/utils/helper/helper_function.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _reEnterPasswordController = TextEditingController();
  bool _showOtpField = false;
  bool _showPasswordFields = false;
  bool _isPasswordMatch = true;
  bool _passwordVisible = false;
  bool _isReenterPasswordVisible = false;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _reEnterPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      return Container(
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: maxHeight * 0.07),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text('Forgot Password',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: maxHeight * 0.07),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.quicksand(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email, color: Colors.white),
                      labelStyle: GoogleFonts.quicksand(color: Colors.white),
                      hintStyle: GoogleFonts.quicksand(
                          color: Colors.white.withOpacity(0.5)),
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    cursorColor: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  if (_showOtpField)
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.quicksand(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        prefixIcon:
                            const Icon(Icons.vpn_key, color: Colors.white),
                        labelStyle: GoogleFonts.quicksand(color: Colors.white),
                        hintStyle: GoogleFonts.quicksand(
                            color: Colors.white.withOpacity(0.5)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      cursorColor: Colors.white,
                    ),
                  const SizedBox(height: 15),
                  if (_showPasswordFields) ...[
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible,
                      style: GoogleFonts.quicksand(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        labelStyle: GoogleFonts.quicksand(color: Colors.white),
                        hintStyle: GoogleFonts.quicksand(
                            color: Colors.white.withOpacity(0.5)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      cursorColor: Colors.white,
                      validator: (val) {
                        if (val!.length < 8) {
                          return "Password must be at least 8 characters";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _reEnterPasswordController,
                      obscureText: !_isReenterPasswordVisible,
                      style: GoogleFonts.quicksand(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Re-enter Password',
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        labelStyle: GoogleFonts.quicksand(color: Colors.white),
                        hintStyle: GoogleFonts.quicksand(
                            color: Colors.white.withOpacity(0.5)),
                        fillColor: Colors.white.withOpacity(0.1),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isReenterPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isReenterPasswordVisible =
                                  !_isReenterPasswordVisible;
                            });
                          },
                        ),
                      ),
                      cursorColor: Colors.white,
                      onChanged: (val) {
                        setState(() {
                          _isPasswordMatch = val == _passwordController.text;
                        });
                      },
                    ),
                    if (!_isPasswordMatch)
                      Text(
                        "Passwords do not match",
                        style: GoogleFonts.quicksand(color: Colors.red),
                      ),
                  ],
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                    ),
                    onPressed: _showPasswordFields
                        ? _resetPassword
                        : _handleEmailSubmit,
                    child: Text(
                      _showPasswordFields ? 'Reset Password' : 'Submit OTP',
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF082c44)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _handleEmailSubmit() async {
    String email = _emailController.text;
    try {
      final response = await Dio().post(
        Constants.forgot,
        options: Options(
          headers: {"Content-Type": "application/json"},
          validateStatus: (status) => status! < 1000,
        ),
        data: {"studentEmail": email},
      );
      if (response.statusCode == 200) {
        showToast("OTP sent to your email");
        await HelperFunctions.saveOTPTokenSF(response.data["SECRET_TOKEN"]);
        setState(() {
          _showOtpField = true;
          _showPasswordFields = true;
        });
      } else if (response.statusCode == 400) {
        showToast(response.data['MESSAGE'] ??
            "Something went wrong, try again later");
      } else if (response.statusCode == 500) {
        showToast("Something went wrong, try again later");
      }
    } catch (e) {
      showToast("Something went wrong");
    }
  }

  Future<void> _resetPassword() async {
    if (_isPasswordMatch) {
      String otp = _otpController.text;
      var bytes = utf8.encode(otp);
      var digest = sha256.convert(bytes);
      String hashedOtp = digest.toString();
      String password = _passwordController.text;
      var bytes2 = utf8.encode(password);
      var digest2 = sha256.convert(bytes2);
      String hashedPass = digest2.toString();
      String? token = await HelperFunctions.getOTPTokenKeyFromSF();

      try {
        final response = await Dio().post(
          Constants.reset,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $token",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "otp": hashedOtp,
            "studentPassword": hashedPass,
          },
        );

        if (response.statusCode == 200) {
          showToast("Password Reset Successful");
          setState(() {
            _showPasswordFields = false;
            _showOtpField = false;
          });

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const PrimaryScreen();
            }),
            (route) => false,
          );

        } else if (response.statusCode == 400) {
          showToast(response.data['MESSAGE'] ??
              "Something went wrong, try again later");
        } else if (response.statusCode == 401) {
          showToast("Unauthorized access");
        } else if (response.statusCode == 500) {
          showToast("Something went wrong , try again later");
        }
      } catch (e) {
        showToast("Something went wrong");
      }
    } else {
      showToast("Passwords do not match!");
    }
  }
}
