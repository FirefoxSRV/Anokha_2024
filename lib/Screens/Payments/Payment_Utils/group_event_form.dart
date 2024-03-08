
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/MyDelightToastBar.dart';
import '../../../constants.dart';
import '../../Auth/primary_page.dart';
import '../payment_screen.dart';




class RegisterToGroupEventPage extends StatefulWidget {
  const RegisterToGroupEventPage({super.key, required this.eventData});

  final Map<String, dynamic> eventData;

  @override
  State<RegisterToGroupEventPage> createState() => _RegisterToGroupEventPageState();
}

class _RegisterToGroupEventPageState extends State<RegisterToGroupEventPage> {
  final _formKey = GlobalKey<FormState>();
  late int dropdownValue;
  bool _isLoading=false;
  TextEditingController teamname = TextEditingController();
  TextEditingController teamleader = TextEditingController();
  TextEditingController teamleaderrole = TextEditingController();
  final List<TextEditingController> _controller1 = []; // to store email id of members
  final List<TextEditingController> _controller2 = [];
  List<String> mailList=[];
  List<String> roleList=[];
  late Map<String, dynamic> trans_map;
  var teamSizeList = <int>[];

  // to store role of members in order
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 12; i++) {
      _controller1.add(TextEditingController());
    }
    for (int i = 0; i < 12; i++) {
      _controller2.add(TextEditingController());
    }
    dropdownValue = widget.eventData['minTeamSize'];
    if (widget.eventData['minTeamSize'] != widget.eventData['maxTeamSize']) {

      for (var i = widget.eventData["minTeamSize"];
      i <= widget.eventData["maxTeamSize"];
      i++) {
        teamSizeList.add(i);
      }

    }
    // setState(() {
    //   teamleader.text = 'Rajyasri';
    // teamleaderrole.text = 'Leader';
    // });

    SharedPreferences.getInstance().then((sp) {
      setState(() {
        teamleader.text = sp.getString("EMAIL")!;
        teamleaderrole.text = "Team Leader";
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the TextEditingControllers to free up resources.
    teamname.dispose();
    teamleader.dispose();
    teamleaderrole.dispose();
    _controller1.forEach((controller) => controller.dispose());
    _controller2.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 221, 235, 248),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text(
                      "Registration Details",
                      style: GoogleFonts.quicksand(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "for",
                        style: GoogleFonts.quicksand(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 44, 68),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.eventData["eventName"],
                        style: GoogleFonts.quicksand(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 44, 68),
                        ),
                      ),
                      if (widget.eventData["minTeamSize"] ==
                          widget.eventData["maxTeamSize"])
                        SizedBox(
                          width: 5,
                        ),
                      if (widget.eventData["minTeamSize"] ==
                          widget.eventData["maxTeamSize"])
                        Text(
                          "(Team Size ",
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 44, 68),
                          ),
                        ),
                      if (widget.eventData["minTeamSize"] ==
                          widget.eventData["maxTeamSize"])
                        Text(
                          widget.eventData["minTeamSize"].toString(),
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 44, 68),
                          ),
                        ),
                      if (widget.eventData["minTeamSize"] ==
                          widget.eventData["maxTeamSize"])
                        Text(
                          ")",
                          style: GoogleFonts.quicksand(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 8, 44, 68),
                          ),
                        ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Team Name",
                        style: GoogleFonts.quicksand(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: TextFormField(
                      controller: teamname,
                      cursorColor: Colors.black,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the team name';
                        }
                        return null;
                      },
                      style:
                      TextStyle(color: const Color.fromARGB(255, 5, 5, 5)),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(20)),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 254, 254, 255),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 178, 172, 172),
                            width: 1,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 172, 28, 28),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (widget.eventData["minTeamSize"] !=
                      widget.eventData["maxTeamSize"])
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Team Size",
                          style: GoogleFonts.quicksand(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade900,
                          ),
                        ),
                      ),
                    ),
                  if (widget.eventData["minTeamSize"] !=
                      widget.eventData["maxTeamSize"]) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select the team size';
                          }
                          return null;
                        },
                        autofocus: false,
                        isExpanded: false,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 251, 251, 251),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 161, 161, 161),
                              width: 1,
                            ),
                          ),
                        ),
                        hint: const Text('Select your Team size'),
                        dropdownColor: Colors.white,
                        value: dropdownValue,
                        onChanged: (int? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: teamSizeList
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],



                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email ID",
                        style: GoogleFonts.quicksand(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextField(
                      enabled: false,
                      controller: teamleader,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.grey.shade900),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 242, 240, 240),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Role in Team",
                        style: GoogleFonts.quicksand(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: TextField(
                      enabled: false,
                      controller: teamleaderrole,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.grey.shade900),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 242, 240, 240),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                const Color.fromARGB(255, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255),
                            width: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (int i = 1; i < dropdownValue; i += 1) ...[
                    if(widget.eventData["needGroupData"]=="1") ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email ID",
                            style: GoogleFonts.quicksand(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the email id';
                            }
                            return null;
                          },
                          controller: _controller1[i],
                          cursorColor: Colors.black,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 5, 5)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 254, 254, 255),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 178, 172, 172),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Role in Team",
                            style: GoogleFonts.quicksand(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the role ';
                            }
                            return null;
                          },
                          controller: _controller2[i],
                          cursorColor: Colors.black,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 5, 5)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 254, 254, 255),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(20)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 178, 172, 172),
                                width: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 26, 15, 0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 8, 44, 68),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.width * 0.2),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              //valid flow
                              _register();
                              // showToast("register");
                            }
                          },
                          child: Text(
                            "Submit",
                            style: GoogleFonts.quicksand(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void _register() async {
    setState(() {
      for (int i = 1; i < dropdownValue; i += 1) {
        mailList.add(_controller1[i].text.toString().trim());
        roleList.add(_controller2[i].text.toString().trim());
      }
    });
    setState(() {
      _isLoading = true;
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
              "Authorization": "Bearer ${secretToken}",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "eventId": widget.eventData['eventId'],
            "totalMembers": dropdownValue,
            "isMarketPlacePaymentMode": "0",
            "teamName": teamname.text.toString(),
            "teamMembers": mailList,
            "memberRoles": roleList,
          },
        );
        if (kDebugMode) {
          print("[REGISTER EVENT]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }
        if (response.statusCode == 200) {
          trans_map = response.data;
          debugPrint("Trans map sent to payment screen${trans_map.toString()}");
          // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(
          //   transData: trans_map,
          // )));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentScreen(
            transData: trans_map,
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
              context, MaterialPageRoute(builder: (context) => const PrimaryScreen()),(route)=>false);
        }
      });
    } catch (err) {
      // Something went wrong. Unknown Error. Handle It.
      showToast(err.toString());
    } finally {
      setState(() {
        _isLoading = false;
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
        context, MaterialPageRoute(builder: (context) => const PrimaryScreen()),(route)=>false);
  }
}