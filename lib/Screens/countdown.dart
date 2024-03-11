import 'package:anokha/Screens/Auth/primary_page.dart';
import 'package:anokha/Screens/Events/events_page.dart';
import 'package:anokha/Screens/Events/specific_event.dart';
import 'package:anokha/Screens/crew_page.dart';
import 'package:anokha/constants.dart';
import 'package:anokha/utils/alert_dialog.dart';
import 'package:anokha/utils/loading_component.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Add this import to format dates
import 'package:shared_preferences/shared_preferences.dart';

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  CountdownPageState createState() => CountdownPageState();
}

class CountdownPageState extends State<Countdown>
    with TickerProviderStateMixin {
  late ScrollController scrollController;
  List<dynamic> events = [];
  List<Map<String, dynamic>> pastEvents = [];
  List<Map<String, dynamic>> todaysEvents = [];
  List<Map<String, dynamic>> upcomingEvents = [];
  String email = "",
      name = "",
      phone = "",
      college = "",
      city = "",
      studentId = "",
      qrText = "",
      needPassport = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    setState(() {
      Future.microtask(() async {
        try {
          List<dynamic> registeredEvents = await fetchRegisteredEvents();
          if (kDebugMode) {
            print(registeredEvents);
          }
          if (kDebugMode) {
            print("Registered Events: ${registeredEvents.length}");
          }
          events = registeredEvents;
          categorizeEvents();
        } catch (e) {
          if (kDebugMode) {
            print("Error fetching registered events: $e");
          }
        }
      });
    });

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void categorizeEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    pastEvents.clear();
    todaysEvents.clear();
    upcomingEvents.clear();

    for (var event in events) {
      DateTime eventDate = DateFormat('yyyy-MM-dd').parse(event['eventDate']);

      if (eventDate.isBefore(today)) {
        pastEvents.add(event);
      } else if (eventDate.isAtSameMomentAs(today)) {
        todaysEvents.add(event);
      } else {
        upcomingEvents.add(event);
      }
    }

    setState(() {});
  }

  Future<List<dynamic>> fetchRegisteredEvents() async {
    setState(() {
      isLoading = true;
    });

    try {
      final sp = await SharedPreferences.getInstance();
      final secretToken = sp.getString("TOKEN") ?? "";
      // debugPrint(secretToken);
      // Check if token is available
      if (secretToken.isEmpty) {
        throw Exception('Authorization token not found.');
      }

      var dio = Dio();
      final response = await dio.get(
        Constants.getRegisteredEvents,
        options: Options(
          headers: {
            "Authorization": "Bearer $secretToken",
          },
          validateStatus: (status) => status! < 1000,
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> eventsData = response.data['EVENTS'];
        // List<EventModel> events = eventsData.map((eventJson) => EventModel.fromMap(eventJson)).toList();
        return eventsData;
      } else {
        // Handle non-200 responses
        throw Exception(
            'Failed to load registered events. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio errors (timeouts, no internet, etc.)
      throw Exception(
          'Failed to load registered events. Dio error: ${e.message}');
    } catch (e) {
      // Handle any other errors
      throw Exception('An unknown error occurred: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const CrewPage();
                  }));
                },
                icon: const Icon(
                  Icons.people,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return LayoutBuilder(builder: (context, constraints) {
                          double width = constraints.maxWidth;
                          double height = constraints.maxHeight;
                          return CustomAlertDialog(
                            width: width,
                            height: height,
                            title: "Logout",
                            content: "Do you want to Logout?",
                            actions: [
                              MaterialButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('No',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              MaterialButton(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side:
                                        const BorderSide(color: Colors.white)),
                                onPressed: () {
                                  _logOut();
                                  showToast("Logout successful");
                                },
                                child: const Text('Yes',
                                    style: TextStyle(
                                        color: Color.fromRGBO(11, 38, 59, 1))),
                              ),
                            ],
                          );
                        });
                      });
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/Images/anokha2024_logo.webp',
                      width: constraints.maxWidth * 0.8,
                    ),
                  ),
                  const Center(
                    child: Chip(
                      label: Text(
                        "# DareToBeDifferent",
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Image.asset("assets/Images/footer_image_white.webp"),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Amrita Vishwa Vidyapeetham's Coimbatore Campus hosts Anokha, a lively tech extravaganza! This dynamic 3-day event brings together students, professionals, and tech enthusiasts from across the nation for exciting competitions, workshops, and interactive sessions covering engineering, robotics, AI, and sustainable technologies. More than just a competition, Anokha is a celebration of collaboration and knowledge exchange. With diverse events catering to different interests and skill sets, it's a vibrant showcase of curiosity and creativity. Beyond tech, Anokha incorporates cultural elements, creating a festive and engaging atmosphere.",
                    style: GoogleFonts.quicksand(
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  if (isLoading == true) ...[
                    const SizedBox(
                      height: 64,
                    ),
                    const LoadingComponent(),
                  ] else ...[
                    if (pastEvents.isNotEmpty ||
                        todaysEvents.isNotEmpty ||
                        upcomingEvents.isNotEmpty) ...[
                      Center(
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  scrollController.animateTo(
                                    MediaQuery.of(context).size.height * 0.8,
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    curve: Curves.decelerate,
                                  );
                                },
                                icon: const Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Color.fromRGBO(11, 38, 59, 1),
                                ),
                                label: Text(
                                  "Registered Events",
                                  style: GoogleFonts.quicksand(
                                      color:
                                          const Color.fromRGBO(11, 38, 59, 1)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    if (pastEvents.isNotEmpty) ...[
                      eventTimeline("Past Events", pastEvents)
                    ],
                    if (todaysEvents.isNotEmpty) ...[
                      eventTimeline("Today's Events", todaysEvents)
                    ],
                    if (upcomingEvents.isNotEmpty) ...[
                      eventTimeline("Upcoming Events", upcomingEvents)
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget eventTimeline(String title, List<Map<String, dynamic>> events) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 10, horizontal: 20), // Adjust padding
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10), // Add space between title and events
          if (events.isNotEmpty) ...[

            for(int i = 0; i < events.length; i++) ...[
              const SizedBox(
                height: 10,
              ),
              EventCard(
                event: events[i],
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                        FadeTransition(
                          opacity: animation,
                          child:
                          EventDetailPage(eventId: events[i]["eventId"]),
                        ),
                  ));
                },
              ),
            ],
          ] else ...[
            Text(
              "No events found",
              style: GoogleFonts.quicksand(color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  void _logOut() {
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("LOGGEDINKEY", false);
      sp.setString("NAME", "");
      sp.setString("EMAIL", "");
      sp.setString("PHONE", "");
      sp.setString("COLLEGE", "");
      sp.setString("CITY", "");
      sp.setString("TOKEN", "");
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
        (route) => false);
  }
}

//
