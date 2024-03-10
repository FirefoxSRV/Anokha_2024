// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:anokha/utils/toast_message.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../utils/helper/helper_function.dart';
import 'otp_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Form and controllers initialization
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _collegeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  bool _confirmPasswordVisible = false;
  bool _passwordVisible = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPasswordMatch = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    _cityController.dispose();
    _confirmPasswordController.dispose();

    _animationController.dispose();
    super.dispose();
  }

  bool _isFromCampus = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      return Scaffold(
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary))
            : ScaleTransition(
                scale: _scaleAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(height: maxHeight * 0.038),
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
                                    )
                                  ],
                                ),
                                const Spacer(flex: 2),
                                SizedBox(height: maxHeight * 0.02),
                                const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontFamily: 'AbrilFatface',
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: maxHeight * 0.028),
                                customTextField(
                                  false,
                                  'Enter your name',
                                  'Name',
                                  Icons.person,
                                  _nameController,
                                  (val) {
                                    //validator
                                    if (val!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return "Name cannot be empty";
                                    }
                                  },
                                ),
                                SizedBox(height: maxHeight * 0.028),
                                customTextField(
                                  false,
                                  'Enter your email',
                                  'Email',
                                  Icons.email,
                                  _emailController,
                                  (val) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(val!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                                SizedBox(height: maxHeight * 0.028),
                                customTextField(
                                  !_passwordVisible,
                                  'Enter your password',
                                  'Password',
                                  Icons.lock,
                                  _passwordController,
                                  (val) {
                                    if (val!.length < 8) {
                                      return "Password must be at least 8 characters";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: maxHeight * 0.028),
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_confirmPasswordVisible,
                                  cursorColor: Colors.white,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    labelText: "Re-Enter Password",
                                    hintStyle: GoogleFonts.quicksand(
                                        color: Colors.white.withOpacity(0.5)),
                                    labelStyle: GoogleFonts.quicksand(
                                        color: Colors.white),
                                    hintText: "Confirm Password",
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.1),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.white),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _confirmPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        // Update the state i.e. toggle the state of passwordVisible variable
                                        setState(() {
                                          _confirmPasswordVisible =
                                              !_confirmPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _isPasswordMatch =
                                          val == _passwordController.text;
                                    });
                                  },
                                ),
                                SizedBox(height: maxHeight * 0.028),
                                customTextField(
                                  false,
                                  'Enter your phone number',
                                  'Phone',
                                  Icons.phone,
                                  _phoneController,
                                  (val) {
                                    if (val!.length != 10) {
                                      return null;
                                    } else {
                                      return "Phone Number should be of 10 digits";
                                    }
                                  },
                                ),
                                SizedBox(height: maxHeight * 0.014),
                                CheckboxListTile(
                                  title: const Text("Are you from this campus?",
                                      style: TextStyle(color: Colors.white)),
                                  value: _isFromCampus,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _isFromCampus = value!;
                                      if (_isFromCampus) {
                                        _collegeController.text =
                                            "Amrita Vishwa Vidyapeetham";
                                        _cityController.text = "Coimbatore";
                                      }
                                    });
                                  },
                                  activeColor: Colors.white,
                                  checkColor: const Color(0xFF264A62),
                                ),
                                SizedBox(height: maxHeight * 0.014),
                                customTextField(
                                    false,
                                    'Enter your college name',
                                    'College',
                                    Icons.school,
                                    _collegeController, (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "College Name cannot be empty";
                                  }
                                }, enabled: !_isFromCampus),
                                SizedBox(height: maxHeight * 0.028),
                                customTextField(
                                    false,
                                    'Enter your city',
                                    'City',
                                    Icons.location_city,
                                    _cityController, (val) {
                                  if (val!.isNotEmpty) {
                                    return null;
                                  } else {
                                    return "City cannot be empty";
                                  }
                                }, enabled: !_isFromCampus),
                                SizedBox(height: maxHeight * 0.028),
                                if (!_isPasswordMatch)
                                  Text(
                                    "Passwords do not match",
                                    style:
                                        GoogleFonts.poppins(color: Colors.red),
                                  ),
                                SizedBox(
                                  height: maxHeight * 0.028,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    register();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                  ),
                                  child: const Text(
                                    "REGISTER",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF264A62)),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                const Spacer(flex: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  TextFormField customTextField(
      bool obscureText,
      String hintText,
      String labelText,
      IconData icon,
      TextEditingController controller,
      String? Function(String?)? validator,
      {bool enabled = true}) {
    return TextFormField(
        obscureText: obscureText,
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(30))),
          hintStyle:
              GoogleFonts.quicksand(color: Colors.white.withOpacity(0.5)),
          labelStyle: GoogleFonts.quicksand(color: Colors.white),
          labelText: labelText,
          hintText: hintText,
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(icon, color: Colors.white),
          suffixIcon: labelText == 'Password'
              ? IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Update the state i.e. toggle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                )
              : null,
        ),
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        validator: validator);
  }

  register() async {
    var bytes =
        utf8.encode(_passwordController.text.toString()); // data being hashed
    var digest = sha256.convert(bytes);
    var hashedPass = digest.toString();

    try {
      setState(() {
        _isLoading = true;
      });

      // login API call
      //print('${_nameController.text.toString()} ${_emailController.text.toString()} ${_phoneController.text.toString()} ${_passwordController.text.toString()} ${_collegeController.text.toString()} ${_cityController.text.toString()}');
      final response = await Dio().post(
        Constants.register,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) =>
              status! < 1000, // This line is extremely important
        ),
        data: {
          "studentFullName":
              _nameController.text.toString(), // Max 255 chars. Min 1 char.
          "studentEmail":
              _emailController.text.toString(), // Valid Email. Max 255 chars.
          "studentPhone": _phoneController.text.toString(), // 10-digit exactly.
          "studentPassword": hashedPass,
          "studentCollegeName": _collegeController.text.toString(),
          "studentCollegeCity": _cityController.text.toString(),
        },
      );

      if (kDebugMode) {
        print("[REGISTER]: ${response.data}");
        print("[STATUS]: ${response.statusCode}");
      }

      if (response.statusCode == 200) {
        // saving the shared preference state

        await HelperFunctions.saveOTPTokenSF(response.data["SECRET_TOKEN"]);

        // should go to otp screen
        showToast("OTP sent successfully");

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterOtpScreen()));

        return "1";
      } else if (response.statusCode == 400) {
        showToast(response.data['MESSAGE'] ??
            "Something went wrong! Please try again later.");
        return "-1";
      }

      showToast(
          "Something went wrong. We're looking into it. Please try again later.");
      return "-1";
    } catch (err) {
      if (kDebugMode) {
        print("[ERROR]: $err");
      }

      showToast(
          "Something went wrong. We're looking into it. Please try again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
