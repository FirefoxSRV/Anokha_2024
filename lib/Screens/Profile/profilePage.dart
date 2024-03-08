
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/MyDelightToastBar.dart';
import '../../constants.dart';
import '../../utils/AlertDialog.dart';
import '../Auth/primary_page.dart';
import '../Payments/Payment_Utils/buy_passport.dart';
import 'Transactions/viewTransaction.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _college = TextEditingController();
  final TextEditingController _city = TextEditingController();
  bool _isLoading = false;
  String email = "",
      name = "",
      phone = "",
      college = "",
      city = "",
      studentId = "",
      qrText = "",
      needPassport = "",
      accountStatus = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      SharedPreferences.getInstance().then((sp) {
        setState(() {
          email = sp.getString("EMAIL")!;
          name = sp.getString("NAME")!;
          phone = sp.getString("PHONE")!;
          college = sp.getString("COLLEGE")!;
          city = sp.getString("CITY")!;
          studentId = sp.getString("STUDENTID")!;
          needPassport = sp.getString("PASSPORT")!;

          // qrText = needPassport == "1"
          //     ? "User needs Passport, give instructions accordingly"
          //     : "User doesn't need Passport , give instructions accordingly";

          qrText="This is your unique QR code";

          _getProfileData();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 44, 68),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.32,
                ),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 8, 44, 68),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Center(
                      child: Text(
                        "Profile",
                        style: GoogleFonts.nunito(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.height * 0.08,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.network(
                            "https://www.gravatar.com/avatar/${email}.jpg?s=200&d=robohash"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          name.toString(),
                          style: GoogleFonts.nunito(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                ),
              ),
              Container(
                // constraints: BoxConstraints(
                //   minHeight: MediaQuery.of(context).size.height * 0.7,
                // ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if(accountStatus=="1")...[
                      InkWell(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BuyPassportWaitingScreen()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              top:
                              MediaQuery.of(context).size.width *0.05,
                              left:20,
                              right:20),
                          child: Container(
                            width: double
                                .infinity, // Expand the container to occupy all available width
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius
                                  .all(
                                  Radius.circular(
                                      25)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors
                                      .grey.shade500,
                                  offset: const Offset(
                                      5, 5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  offset: const Offset(
                                      -1, -1),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 30,top:30,bottom:30,right:20),
                              child: Row(
                                crossAxisAlignment:CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration:
                                    BoxDecoration(
                                      color: Colors
                                          .red[100],
                                      borderRadius:
                                      const BorderRadius
                                          .all(
                                          Radius.circular(
                                              7)),
                                    ),
                                    child:
                                    const Padding(
                                      padding:EdgeInsets.all(5),
                                      child: Icon(
                                        Icons.badge_rounded,
                                        color: Colors.redAccent,
                                        size: 35,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width:15), // Add some spacing between the icon and text
                                  Flexible(
                                    child: Text(
                                      "You need passport to register for events. Buy passport now!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts
                                          .nunito(
                                        fontSize: 13,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: Colors
                                            .black,
                                      ),
                                      softWrap: true,
                                      overflow:
                                      TextOverflow
                                          .visible,
                                    ),
                                  ),
                                  // const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(left:20),
                                    child: Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ],
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          left: 20,
                          right: 20,
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.275,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(5, 5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-5, -5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ]),
                          child: Column(
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0675,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width*0.20,
                                            child: Text(
                                              "Email",
                                              style: GoogleFonts.nunito(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width*0.56,
                                          child: Text(
                                            email,
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.nunito(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(
                                  color: Colors.grey[400],
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1,
                                  height: 0),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0675,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "Phone Number",
                                            style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          phone,
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(
                                  color: Colors.grey[400],
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1,
                                  height: 0),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0675,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "College",
                                            style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          college,
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  )),
                              Divider(
                                  color: Colors.grey[400],
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1,
                                  height: 0),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.0675,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "City",
                                            style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Text(
                                          city,
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.nunito(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.070,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(5, 5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-5, -5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ]),
                          child: InkWell(
                            onTap: () {
                              SharedPreferences.getInstance().then((sp) {
                                setState(() {
                                  _name.text = sp.getString("NAME")!;
                                  _phone.text = sp.getString("PHONE")!;
                                  _college.text = sp.getString("COLLEGE")!;
                                  _city.text = sp.getString("CITY")!;
                                });
                              });
                              showModalBottomSheet(
                                  backgroundColor: Colors.grey[200],
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),
                                    ),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width,
                                  ),
                                  enableDrag: true,
                                  useSafeArea: true,
                                  isDismissible: true,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Form(
                                          key: _editProfileFormKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Edit Profile",
                                                    style: GoogleFonts.nunito(
                                                      fontSize: 24.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 40,
                                                                right: 20,
                                                                bottom: 5),
                                                        child: Text(
                                                          "Profile Name",
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                    ),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.085,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              offset:
                                                                  const Offset(
                                                                      5, 5),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                            const BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                              offset: Offset(
                                                                  -1, -1),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                            controller: _name,
                                                            autofocus: true,
                                                            decoration: const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon: Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            8,
                                                                            44,
                                                                            68))),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 40,
                                                                bottom: 5),
                                                        child: Text(
                                                          "Phone Number",
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                    ),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.085,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              offset:
                                                                  const Offset(
                                                                      5, 5),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                            const BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                              offset: Offset(
                                                                  -1, -1),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                            controller: _phone,
                                                            decoration: const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon: Icon(
                                                                    Icons.phone,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            8,
                                                                            44,
                                                                            68))),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 40,
                                                                bottom: 5),
                                                        child: Text(
                                                          "College Name",
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                    ),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.085,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              offset:
                                                                  const Offset(
                                                                      5, 5),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                            const BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                              offset: Offset(
                                                                  -1, -1),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                            controller:
                                                                _college,
                                                            decoration: const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon: Icon(
                                                                    Icons
                                                                        .school,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            8,
                                                                            44,
                                                                            68))),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 10,
                                                                left: 40,
                                                                bottom: 5),
                                                        child: Text(
                                                          "City",
                                                          style: GoogleFonts
                                                              .nunito(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .grey[
                                                                      700]),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 10,
                                                    ),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.085,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          25)),
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .shade400,
                                                              offset:
                                                                  const Offset(
                                                                      5, 5),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                            const BoxShadow(
                                                              color:
                                                                  Colors.white,
                                                              offset: Offset(
                                                                  -1, -1),
                                                              blurRadius: 15,
                                                              spreadRadius: 1,
                                                            ),
                                                          ]),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            style: GoogleFonts
                                                                .nunito(
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                            controller: _city,
                                                            decoration: const InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                prefixIcon: Icon(
                                                                    Icons
                                                                        .location_city,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            8,
                                                                            44,
                                                                            68))),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Some Button
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: MaterialButton(
                                                      onPressed: () {
                                                        _editProfileData();
                                                        _getProfileData();

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                      ),
                                                      minWidth: double.infinity,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 24.0,
                                                          vertical: 16.0),
                                                      color: Color.fromARGB(
                                                          255, 8, 44, 68),
                                                      child: Text(
                                                        "Update",
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue[100],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(7))),
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Icon(
                                          Icons.edit_note,
                                          color: Colors.blueAccent,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    "Edit Profile",
                                    style: GoogleFonts.nunito(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  offset: const Offset(5, 5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                                const BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-5, -5),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                ),
                              ]),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        CupertinoPageRoute(builder: (context) {
                                      return const ViewTransactions();
                                    }));
                                  },
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.0575,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Icon(
                                                  Icons
                                                      .currency_exchange_rounded,
                                                  color: Colors.black,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "My Transactions",
                                            style: GoogleFonts.nunito(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Colors.black,
                                              size: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if(accountStatus=="2")...[
                              Divider(
                                  color: Colors.grey[400],
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1,
                                  height: 6),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.grey[200],
                                        context: context,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                          // minHeight: MediaQuery.of(context).size.height *0.85,
                                        ),
                                        enableDrag: true,
                                        useSafeArea: true,
                                        isDismissible: true,
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                // SizedBox(height: MediaQuery.of(context).size.width *0.05,),
                                                Text(
                                                  "Qr code",
                                                  style: GoogleFonts.nunito(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  25)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade500,
                                                          offset: const Offset(
                                                              5, 5),
                                                          blurRadius: 15,
                                                          spreadRadius: 1,
                                                        ),
                                                        const BoxShadow(
                                                          color: Colors.white,
                                                          offset: const Offset(
                                                              -1, -1),
                                                          blurRadius: 15,
                                                          spreadRadius: 1,
                                                        )
                                                      ]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: QrImageView(
                                                      data:
                                                          "anokha://$studentId",
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.70,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.05,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.1),
                                                  child: Container(
                                                    width: double
                                                        .infinity, // Expand the container to occupy all available width
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  25)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors
                                                              .grey.shade500,
                                                          offset: const Offset(
                                                              5, 5),
                                                          blurRadius: 15,
                                                          spreadRadius: 1,
                                                        ),
                                                        const BoxShadow(
                                                          color: Colors.white,
                                                          offset: const Offset(
                                                              -1, -1),
                                                          blurRadius: 15,
                                                          spreadRadius: 1,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              32.0),
                                                      child: Row(
                                                        crossAxisAlignment:CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blue[100],
                                                              borderRadius:
                                                                  const BorderRadius
                                                                      .all(
                                                                      Radius.circular(
                                                                          7)),
                                                            ),
                                                            child:
                                                                const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              child: Icon(
                                                                Icons
                                                                    .perm_device_info,
                                                                color: Colors
                                                                    .blueAccent,
                                                                size: 35,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(width:15), // Add some spacing between the icon and text
                                                          SizedBox(
                                                            width: MediaQuery.of(context).size.width * 0.4,
                                                            child: Text(
                                                              qrText,
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts
                                                                  .nunito(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: 30,
                                                )

                                                // QrImage()
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.0575,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(7))),
                                              child: Padding(
                                                padding: EdgeInsets.all(3),
                                                child: Icon(
                                                  Icons.qr_code,
                                                  color: Colors.black,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Text(
                                            "QR Code",
                                            style: GoogleFonts.nunito(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Icon(
                                              Icons.arrow_forward_ios_sharp,
                                              color: Colors.black,
                                              size: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ],
                              Divider(
                                  color: Colors.grey[400],
                                  indent: 20,
                                  endIndent: 20,
                                  thickness: 1,
                                  height: 6),
                              InkWell(
                                onTap: () {
                                  showDialog(context: context, builder: (context){

                                    return LayoutBuilder(
                                        builder: (context,constraints) {
                                          double width = constraints.maxWidth;
                                          double height = constraints.maxHeight;
                                          return customAlertDialog(width: width, height: height, title: "Logout",content: "Do you want to Logout?",actions: [
                                            MaterialButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: Text('No',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            MaterialButton(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  side: BorderSide(
                                                      color:Colors.white)),
                                              onPressed: () {
                                                _logOut();
                                                showToast("Logout successful");
                                              },
                                              child: Text('Yes',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(11, 38, 59, 1))),
                                            ),
                                          ],);
                                        }
                                    );
                                  });

                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.0575,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.red[100],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(7))),
                                            child: Padding(
                                              padding: EdgeInsets.all(3),
                                              child: Icon(
                                                Icons.logout_rounded,
                                                color: Colors.red,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                            )),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Logout",
                                          style: GoogleFonts.nunito(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 20),
                                        child: Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height:  MediaQuery.of(context).size.height*0.05,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getProfileData() {
    setState(() {
      _isLoading = true;
    });
    String secretToken = "";
    try {
      SharedPreferences.getInstance().then((sp) {
        setState(() {
          // get secret Token from SP
          secretToken = sp.getString("TOKEN")!;
        });
        if (secretToken == "") {
          // User Is not logged in. Handle it. Navigate back to LoginScreen
          showToast('Token empty');
          //redirect to loginPage
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => const PrimaryScreen()),(route)=>false);
        }

        Dio()
            .get(
          Constants.getProfile,
          options: Options(headers: {
            "Authorization": "Bearer $secretToken",
          }, validateStatus: (status) => status! < 1000),
        )
            .then((res) {
          // showToast("[GETPROFILE] status code: {$res.statusCode}");
          // print("[GETPROFILE] status code: {$res.statusCode}");
          if (res.statusCode == 200) {
            final data = res.data;

            if (kDebugMode) {
              print(data);
            }

            setState(() {
              // Setting the variables
              email = data["studentEmail"].toString();
              name = data["studentFullName"].toString();
              phone = data["studentPhone"].toString();
              college = data["studentCollegeName"].toString();
              city = data["studentCollegeCity"].toString();
              accountStatus = data["studentAccountStatus"].toString();
              if(accountStatus=="0"){
                showToast("Your account is blocked");
                _logOut();
              }


              //saving in SP
              SharedPreferences.getInstance().then((sp) {
                sp.setString("EMAIL", email);
                sp.setString("NAME", name);
                sp.setString("PHONE", phone);
                sp.setString("COLLEGE", college);
                sp.setString("CITY", city);
                sp.setString("STATUS", accountStatus);
              });
            });
          } else if (res.statusCode == 400 && res.data["MESSAGE"] != null) {
            showToast(res.data["MESSAGE"]);
            // _logOut();
          } else if (res.statusCode == 401) {
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

  void _editProfileData() async {
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
          Constants.editProfile,
          options: Options(
            headers: {
              "Authorization": "Bearer ${secretToken}",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {
            "studentFullName":
                _name.text.toString(), // Max 255 chars. Min 1 char.
            "studentPhone": _phone.text.toString(), // 10-digit exactly.
            "studentCollegeName":
                _college.text.toString(), // Max 255 chars. Min 1 char.
            "studentCollegeCity":
                _city.text.toString() // Max 255 chars. Min 1 char.
          },
        );
        if (kDebugMode) {
          print("[EDIT PROFILE]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }
        if (response.statusCode == 200) {
          showToast("Successfully edited profile");
          SharedPreferences.getInstance().then((sp) {
            sp.setString("NAME", _name.text.toString());
            sp.setString("PHONE", _phone.text.toString());
            sp.setString("COLLEGE", _college.text.toString());
            sp.setString("CITY", _city.text.toString());
          });
        } else if (response.statusCode == 401) {
          showToast("Session Expired. Please Login again.");
          // User was logged in. But Session Expired. Handle it. Navigate back to LoginScreen
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
              context, MaterialPageRoute(builder: (context) =>  const PrimaryScreen()),(route)=>false);
        } else {
          // Some unknown error. Handle It
          showToast("Somthing went wrong, Try again after a while");
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

  Future<void> _pullRefresh() async {
    _getProfileData();
    // showToast("Refresh successul");
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
