import 'dart:convert';
import 'package:anokha/Screens/Auth/register_page.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/MyDelightToastBar.dart';
import '../../constants.dart';
import '../../home.dart';
import '../../utils/helper/helper_function.dart';
import 'forgot_page.dart';

class LoginReg extends StatefulWidget {
  const LoginReg({super.key});

  @override
  State<LoginReg> createState() => _LoginRegState();
}

class _LoginRegState extends State<LoginReg> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;
  bool _isPasswordVisible = false;

  late AnimationController _controller;
  late Animation _gradientAnimation;

  @override
  void initState() {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _gradientAnimation = ColorTween(
      begin: const Color(0xFF082c44),
      end: const Color(0xFF3a5e76),
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scaleAnimation = Tween<double>(begin: 0.75, end: 1).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double maxHeight = constraints.maxHeight;
      double maxWidth = constraints.maxWidth;
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          elevation: 0,
          onPressed: (){
            Navigator.pop(context);
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.arrow_back,color: Colors.white,),
        ),
        body: _isLoading
            ? Center(
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary),
        )
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
                          const Spacer(flex: 2),
                          Padding(
                            padding: EdgeInsets.only(
                                left: maxWidth * 0.1,
                                right: maxWidth * 0.1),
                            child: Image.asset(
                                'assets/Images/anokha2024_logo.webp'),
                          ),
                          SizedBox(height: maxHeight * 0.08),
                          Text(
                            "Sign In",
                            style: GoogleFonts.habibi(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: maxHeight * 0.08),
                          customTextField(
                            false,
                            'Enter your email',
                            'Email',
                            _emailFocusNode,
                            Icons.person,
                            _emailController,
                                (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: maxHeight * 0.03),
                          customTextField(
                            !_isPasswordVisible,
                            'Enter your password',
                            'Password',
                            _passwordFocusNode,
                            Icons.lock,
                            _passwordController,
                                (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters";
                              } else {
                                return null;
                              }
                            },
                            onTogglePasswordVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          SizedBox(height: maxHeight * 0.04),
                          ElevatedButton(
                            onPressed: () {
                              login(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor:
                              Theme.of(context).primaryColor,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: maxHeight * 0.02),
                            ),
                            child: Text(
                              "LOGIN",
                              style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF082c44)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));

                            },
                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.quicksand(
                                  color: Colors.white),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't Have an Account? ",
                                style: GoogleFonts.quicksand(
                                    color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () {

                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage()));

                                },
                                child: Text(
                                  "SIGN UP",
                                  style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                              ),
                            ],
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
      FocusNode focusNode,
      IconData icon,
      TextEditingController? textEditingController,
      String? Function(String?)? validator, {
        VoidCallback? onTogglePasswordVisibility,
      } // Added parameter
      ) {
    return TextFormField(
      focusNode: focusNode,
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.quicksand(color: Colors.white),
        hintText: hintText,
        hintStyle: GoogleFonts.quicksand(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: onTogglePasswordVisibility != null
            ? IconButton(
          icon: Icon(
            // Toggle the icon based on the password visibility state
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: onTogglePasswordVisibility,
        )
            : null,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      cursorRadius: const Radius.circular(10),
      cursorColor: Colors.white,
      style: GoogleFonts.quicksand(color: Colors.white),
      validator: validator,
    );
  }

  login(BuildContext context) async {
    var bytes =
    utf8.encode(_passwordController.text.toString()); // data being hashed
    var digest = sha256.convert(bytes);
    var hashedPass = digest.toString();

    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await Dio().post(
          Constants.login,
          options: Options(
            headers: {
              "Content-Type": "application/json",
            },
            validateStatus: (status) =>
            status! < 1000, // This line is extremely important
          ),
          data: {
            "studentEmail":
            _emailController.text.toString(), // Valid EMAIL. Max 255 chars.
            "studentPassword": hashedPass
                .toString() // Min 8 chars. Cannot include '-'(hiphen) and "'"(quotes) as part of the password.
            // Send SHA256 Hashed Version of password.
          },
        );

        if (kDebugMode) {
          print("[LOGIN]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }

        if (response.statusCode == 200) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(
              _emailController.text.toString());
          await HelperFunctions.saveUserNameSF(
              response.data['studentFullName']);
          await HelperFunctions.saveUserTokenSF(response.data["SECRET_TOKEN"]);

          setState(() {
            SharedPreferences.getInstance().then((sp) {
              sp.setString("EMAIL", response.data["studentEmail"].toString());
              sp.setString("NAME", response.data["studentFullName"].toString());
              sp.setString("PHONE", response.data["studentPhone"].toString());
              sp.setString(
                  "COLLEGE", response.data["studentCollegeName"].toString());
              sp.setString(
                  "CITY", response.data["studentCollegeCity"].toString());
              sp.setString("TOKEN", response.data["SECRET_TOKEN"].toString());
              sp.setString("STUDENTID", response.data["studentId"].toString());
              print("STUDENTID ${response.data["studentId"].toString()}");
              sp.setString(
                  "PASSPORT", response.data["needPassport"].toString());
            });
          });

          // MyDelightToastBar().success(context, "Welcome!");
          showToast("Welcome!");
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const HomePage()),(route)=>false);


          return "1";
        } else if (response.statusCode == 400) {
          MyDelightToastBar().error(context, "Invalid Credentials");
          return "-1";
        }

        MyDelightToastBar()
            .error(context, "Something went wrong.Please try again later.");

        return "-1";
      } catch (err) {
        if (kDebugMode) {
          print("[ERROR]: $err");
        }

        MyDelightToastBar()
            .error(context, "Something went wrong.Please try again later.");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
