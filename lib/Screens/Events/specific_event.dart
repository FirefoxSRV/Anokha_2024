import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/MyDelightToastBar.dart';
import '../../constants.dart';
import '../../utils/loading_component.dart';
import '../Auth/login_page.dart';
import '../Auth/primary_page.dart';
import '../Payments/Payment_Utils/group_event_form.dart';
import '../payments/payment_screen.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;
  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  Map<String, dynamic> eventDetails = {};
  DateFormat format = DateFormat("yyyy-MM-dd");

  bool isLoading = true;

  void _getEventData() async {
    setState(() {
      isLoading = true;
    });

    final sp = await SharedPreferences.getInstance();

    if (sp.getString("TOKEN")!.isEmpty) {
      _logOut();
      return;
    }

    try {
      final dio = Dio();

      final response = await dio.get(
        "${Constants.getEventData}/${widget.eventId}",
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {
            "Authorization": "Bearer ${sp.getString("TOKEN")}",
          },
          validateStatus: (status) => status! < 1000,
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          eventDetails = response.data;
        });
      } else if (response.statusCode == 401) {
        _logOut();
      } else if (response.statusCode == 400) {
        showToast(response.data["MESSAGE"] ??
            "Something Went Wrong. We're working on it. Please try Again later.");
      } else {
        showToast(
            "Something Went Wrong. We're working on it. Please try Again later.");
      }
    } catch (e) {
      debugPrint(e.toString());
      //
      showToast(
          "Something Went Wrong. We're working on it. Please try Again later.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getOrdinal(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  String formatEventDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    String monthYear = DateFormat('MMMM').format(date);
    String ordinalDay = getOrdinal(date.day);

    return "$ordinalDay $monthYear";
  }

  Future<String> _toggleStarredEvent() async {
    setState(() {
      isLoading = true;
    });
    final sp = await SharedPreferences.getInstance();

    if (sp.getString("TOKEN")!.isEmpty) {
      return "-1";
    }

    try {
      final dio = Dio();

      final response = await dio.post(Constants.toggleStarredEvents,
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {
              "Authorization": "Bearer ${sp.getString("TOKEN")}",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "eventId": eventDetails["eventId"],
            "isStarred": eventDetails["isStarred"] == "1" ? "0" : "1",
          });

      if (response.statusCode == 200) {
        setState(() {
          eventDetails["isStarred"] =
              eventDetails["isStarred"] == "1" ? "0" : "1";
        });
      } else if (response.statusCode == 401) {
        _logOut();
      } else if (response.statusCode == 400) {
        showToast(response.data["MESSAGE"]);
      } else {
        showToast("Something went wrong.Try again later.");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return "-1";
  }

  Map<String, dynamic> registrationData = {};

  Future<String> _viewRegistration() async {
    setState(() {
      isLoading = true;
    });

    final sp = await SharedPreferences.getInstance();

    if (sp.getString("TOKEN")!.isEmpty) {
      return "-1";
    }

    try {
      final dio = Dio();

      final response = await dio.post(Constants.getRegisteredEventData,
          options: Options(
            contentType: Headers.jsonContentType,
            headers: {
              "Authorization": "Bearer ${sp.getString("TOKEN")}",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "registrationId": eventDetails["registrationId"],
          });

      if (response.statusCode == 200) {
        setState(() {
          registrationData = response.data;
        });

        debugPrint(registrationData.toString());

        return "1";
      } else if (response.statusCode == 401) {
        _logOut();
      } else if (response.statusCode == 400) {
        showToast(response.data["MESSAGE"]);
      } else {
        showToast("Something went wrong.Try again later.");
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return "-1";
  }

  @override
  void initState() {
    super.initState();
    _getEventData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(43, 30, 56, 1),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _toggleStarredEvent();
                },
                icon: Icon(
                  eventDetails['isStarred'] != null
                      ? eventDetails['isStarred'] == "1"
                          ? Icons.favorite
                          : Icons.favorite_border
                      : Icons.favorite_border,
                  color: Colors.white,
                ))
          ],
        ),
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        bottomSheet: BottomSheet(
          onClosing: () {},
          builder: (context) {
            return SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 96,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (isLoading == false) ...[
                      eventDetails['isRegistered'] == "1"
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FloatingActionButton.extended(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                backgroundColor: const Color.fromRGBO(11, 38, 59, 1),
                                extendedPadding: const EdgeInsetsDirectional.all(16),
                                onPressed: () {
                                  _viewRegistration().then((res) {
                                    if (res == "1") {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16.0),
                                              topRight: Radius.circular(16.0),
                                            ),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          enableDrag: true,
                                          useSafeArea: true,
                                          isDismissible: true,
                                          showDragHandle: true,
                                          isScrollControlled: true,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Registration Details",
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 4.0),
                                                    child: ListTile(
                                                      style: ListTileStyle.list,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.0),
                                                      ),
                                                      dense: true,
                                                      title: Text(
                                                        "₹ ${registrationData["transactionAmount"].toString()}",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      subtitle: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            DateFormat(
                                                                    'EEE, MMM d, '
                                                                    'yy')
                                                                .format(DateTime.parse(
                                                                    registrationData[
                                                                        "transactionTime"])),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                          Text(
                                                            DateFormat('h:MM a')
                                                                .format(DateTime.parse(
                                                                    registrationData[
                                                                        "transactionTime"])),
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                            textAlign:
                                                                TextAlign.start,
                                                          )
                                                        ],
                                                      ),
                                                      trailing: Chip(
                                                        avatar: registrationData[
                                                                    'transactionStatus'] ==
                                                                '1'
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .not_interested_rounded,
                                                                color:
                                                                    Colors.red),
                                                        elevation: 1,
                                                        color: MaterialStateProperty
                                                            .all(registrationData[
                                                                        'transactionStatus'] ==
                                                                    '1'
                                                                ? Colors
                                                                    .lightGreenAccent
                                                                    .withOpacity(
                                                                        0.2)
                                                                : Colors
                                                                    .redAccent
                                                                    .withOpacity(
                                                                        0.2)),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                        ),
                                                        side: BorderSide(
                                                          color: registrationData[
                                                                      'transactionStatus'] ==
                                                                  '1'
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        label: Text(
                                                          registrationData[
                                                                      'transactionStatus'] ==
                                                                  '1'
                                                              ? "Success"
                                                              : "Failure",
                                                          style: GoogleFonts
                                                              .nunito(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: registrationData[
                                                                        'transactionStatus'] ==
                                                                    '1'
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  if (eventDetails["isGroup"] ==
                                                      "1") ...[
                                                    Text(
                                                      registrationData[
                                                              "teamName"]
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .sourceCodePro(
                                                        textStyle: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    const Divider(
                                                      thickness: 1,
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    for (int i = 0;
                                                        i <
                                                            registrationData[
                                                                    "team"]
                                                                .length;
                                                        i++) ...[
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              registrationData[
                                                                      "team"][i]
                                                                  [
                                                                  "studentFullName"],
                                                              style: GoogleFonts
                                                                  .sourceCodePro(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              registrationData[
                                                                      "team"][i]
                                                                  [
                                                                  "roleDescription"],
                                                              style: GoogleFonts
                                                                  .sourceCodePro(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              registrationData[
                                                                      "team"][i]
                                                                  [
                                                                  "studentEmail"],
                                                              style: GoogleFonts
                                                                  .sourceCodePro(
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 4,
                                                      ),
                                                    ],
                                                  ],
                                                ],
                                              ),
                                            );
                                          });
                                    }
                                  });
                                },
                                label: Text(
                                  "Show Registration",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white),
                                ),
                                icon: const Icon(Icons.event_available,
                                    color: Colors.white),
                              ),
                            )
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FloatingActionButton.extended(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                backgroundColor: const Color.fromRGBO(11, 38, 59, 1),
                                extendedPadding: const EdgeInsetsDirectional.all(16),
                                onPressed: () {
                                  if (eventDetails["isGroup"] == "0") {
                                    // showToast("Individual event");
                                    _register(
                                        eventDetails["eventId"].toString(),
                                        eventDetails["minTeamSize"]);
                                  }
                                  if (eventDetails["isGroup"] == "1" &&
                                      eventDetails["needGroupData"] == "0" &&
                                      eventDetails["minTeamSize"] ==
                                          eventDetails["maxTeamSize"]) {
                                    _register(
                                        eventDetails["eventId"].toString(),
                                        eventDetails["minTeamSize"]);
                                  }
                                  if (eventDetails["isGroup"] == "1" &&
                                      eventDetails["needGroupData"] == "0" &&
                                      eventDetails["minTeamSize"] !=
                                          eventDetails["maxTeamSize"]) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterToGroupEventPage(
                                                  eventData: {
                                                    "minTeamSize": eventDetails[
                                                        "minTeamSize"],
                                                    "maxTeamSize": eventDetails[
                                                        "maxTeamSize"],
                                                    "eventName": eventDetails[
                                                        "eventName"],
                                                    "eventId":
                                                        eventDetails["eventId"],
                                                    // "needGroupData":event["needGroupData"],
                                                    "needGroupData": "0",
                                                  },
                                                )));
                                  }
                                  if (eventDetails["isGroup"] == "1" &&
                                      eventDetails["needGroupData"] == "1") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterToGroupEventPage(
                                                  eventData: {
                                                    "minTeamSize": eventDetails[
                                                        "minTeamSize"],
                                                    "maxTeamSize": eventDetails[
                                                        "maxTeamSize"],
                                                    "eventName": eventDetails[
                                                        "eventName"],
                                                    "eventId":
                                                        eventDetails["eventId"],
                                                    "needGroupData":
                                                        eventDetails[
                                                            "needGroupData"],
                                                  },
                                                )));
                                  }
                                },
                                label: Text(
                                  "Register",
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white),
                                ),
                                icon: const Icon(Icons.event_available,
                                    color: Colors.white),
                              ),
                            ),
                    ]
                  ],
                ));
          },
        ),
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
            child: isLoading == true
                ? const LoadingComponent()
                : buildEventDetailPage(
                    eventDetails,
                  )));
  }

  Widget buildEventDetailPage(dynamic event) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Hero(
            tag: 'event-image-${event['eventId']}',
            child: Image.network(
              event['eventImageURL'],
              fit: BoxFit.cover,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 250),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        event['eventName'],
                        style: GoogleFonts.quicksand(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        "₹ ${(event["eventPrice"]*1.18).ceil()}",
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: buildDetailTile(
                              Icons.calendar_today,
                              "${formatEventDate(event['eventDate'].substring(0, 10))} 2024",
                              "Date")),
                      const SizedBox(
                        height: 2,
                      ),
                      const Divider(
                        color: Colors.grey,
                        indent: 15,
                        endIndent: 15,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: buildDetailTile(Icons.access_time,
                              "${event['eventTime']}", "Time")),
                      const SizedBox(
                        height: 2,
                      ),
                      const Divider(color: Colors.grey, indent: 15, endIndent: 15),
                      const SizedBox(
                        height: 2,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: buildDetailTile(
                              Icons.place, "${event['eventVenue']}", "Venue")),
                      const SizedBox(
                        height: 2,
                      ),
                      const Divider(color: Colors.grey, indent: 15, endIndent: 15),
                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: buildDetailTile(
                              Icons.design_services_rounded, "${event['isGroup'] == "1" ? "Group" : "Individual"} ${event['isWorkshop'] == "1" ? "workshop" : "event"}", "Type")),
                      const SizedBox(
                        height: 2,
                      ),
                      event['isGroup'] == "1"
                          ? Column(
                              children: [
                                const Divider(
                                  color: Colors.grey,
                                  indent: 15,
                                  endIndent: 15,
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 10),
                                  child: buildDetailTile(
                                      Icons.person,
                                      "${event['minTeamSize']} - ${event['maxTeamSize']} members",
                                      "Team size"),
                                ),
                              ],
                            )
                          : const SizedBox(
                              height: 10,
                            ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTags(event['tags']),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MarkdownBody(
                          data: event['eventMarkdownDescription'],
                          styleSheet: MarkdownStyleSheet(
                            h2: GoogleFonts.poppins(color: Colors.white),
                            h1: GoogleFonts.poppins(color: Colors.white),
                            p: GoogleFonts.poppins(color: Colors.white),
                            a: GoogleFonts.poppins(color: Colors.white),
                            h3: GoogleFonts.poppins(color: Colors.white),
                            h4: GoogleFonts.poppins(color: Colors.white),
                            h5: GoogleFonts.poppins(color: Colors.white),
                            h6: GoogleFonts.poppins(color: Colors.white),
                            em: GoogleFonts.poppins(color: Colors.white),
                            strong: GoogleFonts.poppins(color: Colors.white),
                            del: GoogleFonts.poppins(color: Colors.white),
                            blockquote: GoogleFonts.poppins(color: Colors.white),
                            img: GoogleFonts.poppins(color: Colors.white),
                            checkbox: GoogleFonts.poppins(color: Colors.white),
                            listBullet: GoogleFonts.poppins(color: Colors.white),
                            tableBody: GoogleFonts.poppins(color: Colors.white),
                            tableHead: GoogleFonts.poppins(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildDetailTile(IconData icon, String text, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color.fromRGBO(11, 38, 59, 1)),
            const SizedBox(
              width: 5,
            ),
            Text(
              title,
              style:
                  GoogleFonts.quicksand(color: const Color.fromRGBO(11, 38, 59, 1)),
            )
          ],
        ),
        Text(text, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  Widget buildTags(List<dynamic> tags) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      children: tags.map((tag) {
        return Chip(
          avatar: CircleAvatar(
            backgroundColor: const Color.fromRGBO(11, 38, 59, 1),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  tag['tagAbbreviation'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          label: Text(tag['tagName']),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(6),
          labelStyle: const TextStyle(
            color: Color.fromRGBO(11, 38, 59, 1),
          ),
        );
      }).toList(),
    );
  }

//
// Widget buildRegisterButton() {
//   return ElevatedButton.icon(
//
//     icon: const Icon(Icons.event_available),
//     label: const Text("Register"),
//     style: ElevatedButton.styleFrom(
//       foregroundColor: Colors.white,
//       backgroundColor: Color.fromRGBO(11,38,59,1),
//       minimumSize: const Size(double.infinity, 50),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.white,width: 0.3)),
//     ),
//   );
// }
  void _register(String eventId, int totalMembers) async {
    setState(() {
      isLoading = true;
    });
    String? secretToken = "";

    try {
      SharedPreferences.getInstance().then((sp) async {
        setState(() {
          secretToken = sp.getString("TOKEN");
        });

        final response = await Dio().post(
          Constants.registerEvent,
          options: Options(
            headers: {
              "Authorization": "Bearer $secretToken",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "eventId": int.parse(eventId),
            "totalMembers": totalMembers,
            "isMarketPlacePaymentMode": "0",
            "teamName": "",
            "teamMembers": [],
            "memberRoles": [],
          },
        );
        if (kDebugMode) {
          print("[REGISTER EVENT]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }
        if (response.statusCode == 200) {
          var transMap = response.data;
          debugPrint("Trans map sent to payment screen${transMap.toString()}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                        transData: transMap,
                      )));
        } else if (response.statusCode == 400 &&
            response.data["MESSAGE"] != null) {
          showToast(response.data["MESSAGE"]);
        } else if (response.statusCode == 401) {
          showToast("Session Expired. Please Login again.");
          // User was logged in. But Session Expired. Handle it. Navigate back to LoginScreen
          _logOut();
        } else {
          // Some unknown error. Handle It
          showToast("Something went wrong please wait");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginReg()),
              (route) => false);
        }
      });
    } catch (err) {
      // Something went wrong. Unknown Error. Handle It.
      showToast(err.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logOut() {
    //clearing the cache
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
