import 'package:anokha/Screens/Auth/login_page.dart';
import 'package:anokha/Screens/Auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';


class PrimaryScreen extends StatefulWidget {
  const PrimaryScreen({super.key});
  @override
  State<PrimaryScreen> createState() => _PrimaryScreenState();
}

class _PrimaryScreenState extends State<PrimaryScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        bottomSheet: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:18,vertical: 8),
                      child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context){
                                return const LoginReg();
                              }),
                            );

                          },
                          color: const Color.fromRGBO(11, 38, 59, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Login',
                              style: GoogleFonts.quicksand(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.w700),
                            ),
                          )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:18,vertical: 8),
                      child: MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(builder: (context){
                                return const RegisterPage();
                              }),
                            );
                          },
                          color: const Color.fromRGBO(11, 38, 59, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Register',
                              style: GoogleFonts.quicksand(fontSize: 20.0, color: Colors.white,fontWeight: FontWeight.w700),
                            ),
                          )
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
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
          child: Center(
            child: Image.asset("assets/Images/anokha2024_logo.webp"),
          ),
        ),
      ),
    );
  }
}
