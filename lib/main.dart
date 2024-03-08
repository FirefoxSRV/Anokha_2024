
import 'package:anokha/Screens/crew_page.dart';
import 'package:anokha/utils/helper/helper_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Screens/Auth/login_page.dart';
import 'Screens/Auth/primary_page.dart';
import 'Screens/Events/events_page.dart';
import 'home.dart';


void main() {
  runApp(
      MyApp()
  );
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
    WidgetsBinding.instance.addPostFrameCallback((_){
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
      routes: {
        '/': (context) => _isSignedIn ? const HomePage() : const PrimaryScreen(),
        // '/': (context) => CrewPage(),

        '/events': (context) => EventsWorkshopsPage(isFeatured: false,),
        '/home': (context) => const HomePage(),
        '/logreg': (context) => const LoginReg(),
      },
    );
  }
}

