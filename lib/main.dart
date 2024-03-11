import 'package:anokha/Screens/Auth/login_page.dart';
import 'package:anokha/Screens/Auth/primary_page.dart';
import 'package:anokha/Screens/Events/events_page.dart';
import 'package:anokha/home.dart';
import 'package:anokha/utils/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      debugPrint(value.toString());
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserLoggedInStatus();
    });
    debugPrint("Hi  --- ${_isSignedIn.toString()}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anokha 2024',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      routes: {
        '/': (context) =>
            _isSignedIn ? const HomePage() : const PrimaryScreen(),
        // '/': (context) => CrewPage(),

        '/events': (context) => const EventsWorkshopsPage(
              isFeatured: false,
            ),
        '/home': (context) => const HomePage(),
        '/logreg': (context) => const LoginReg(),
      },
    );
  }
}
