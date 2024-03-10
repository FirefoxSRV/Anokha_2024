import 'package:anokha/utils/AlertDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/Events/events_page.dart';
import 'Screens/Profile/profilePage.dart';
import 'Screens/countdown.dart';
import 'Utils/navigation_pane.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      scrollBehavior: MyCustomScrollBehavior(),
    );
  }
}

// Custom Scroll Behavior to remove glow effect
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Remove overscroll indicator (glow)
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return LayoutBuilder(builder: (context, constraints) {
                double width = constraints.maxWidth;
                double height = constraints.maxHeight;
                return customAlertDialog(
                  width: width,
                  height: height,
                  title: "Exit ?",
                  content: "This action will exit this app.",
                  actions: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: const Color.fromRGBO(11, 38, 59, 1),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ok",
                        style: GoogleFonts.quicksand(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.quicksand(
                            color: const Color.fromRGBO(11, 38, 59, 1)),
                      ),
                    )
                  ],
                );
              });
            });
        return true;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          physics:
              const NeverScrollableScrollPhysics(), // Prevent manual page swipes
          children: const [
            Countdown(),
            EventsWorkshopsPage(
              isFeatured: false,
            ),
            EventsWorkshopsPage(isFeatured: true),
            UserProfile(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _pageController.jumpToPage(index);
              });
            }),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
