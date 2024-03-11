import 'package:anokha/Screens/Auth/primary_page.dart';
import 'package:anokha/Screens/Payments/payment_screen.dart';
import 'package:anokha/constants.dart';
import 'package:anokha/home.dart';
import 'package:anokha/utils/loading_component.dart';
import 'package:anokha/utils/toast_message.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyPassportWaitingScreen extends StatefulWidget {
  const BuyPassportWaitingScreen({super.key});

  @override
  State<BuyPassportWaitingScreen> createState() =>
      _BuyPassportWaitingScreenState();
}

class _BuyPassportWaitingScreenState extends State<BuyPassportWaitingScreen> {
  bool _isLoading = true;

  int amount = (300 * 1.18).ceil();
  String content =
      "The Anokha passport serves as the exclusive entry ticket, granting access to the Anokha tech fest. All students, excluding those from Amrita Vishwa Vidyapeetham Coimbatore campus, must acquire a passport prior to event and workshop registration. Coimbatore campus students, however, need not purchase a passport but must register using their Amrita email-id. The passport, priced at ₹300 (including GST), ensures entry to the tech fest, while separate registration fees apply to events and workshops. Instead of physical copies, a QR code provided upon passport purchase must be presented for entry throughout the three days of the tech fest.";
  String title = "Anokha Passport";
  String imageUrl = "https://i.imgur.com/iQy8GLM.jpg";

  void _getPassportContentData() async {
    setState(() {
      _isLoading = true;
    });

    final sp = await SharedPreferences.getInstance();

    if (sp.getString("TOKEN")!.isEmpty) {
      _logOut();
      return;
    }

    try {
      final dio = Dio();

      final response = await dio.get(
        Constants.getPassportContent,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          amount = (response.data["amount"] * 1.18).ceil() ?? amount;
          title = response.data["title"] ?? title;
          content = response.data["description"] ?? content;
          imageUrl = response.data["imageUrl"] ?? imageUrl;
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

      showToast(
          "Something Went Wrong. We're working on it. Please try Again later.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _getPassportContentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      floatingActionButton: _isLoading == false
          ? FloatingActionButton.small(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.white)),
              backgroundColor: const Color.fromRGBO(11, 38, 59, 1),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : null,
      bottomSheet: _isLoading == false
          ? BottomSheet(
              onClosing: () {},
              builder: (context) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 96,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: FloatingActionButton.extended(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor:
                                const Color.fromRGBO(11, 38, 59, 1),
                            extendedPadding:
                                const EdgeInsetsDirectional.all(16),
                            onPressed: () {
                              _buyPassport();
                            },
                            label: Text(
                              "Buy Passport",
                              style: GoogleFonts.quicksand(color: Colors.white),
                            ),
                            icon: const Icon(Icons.event_available,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ));
              },
            )
          : null,
      body: _isLoading == true
          ? const LoadingComponent()
          : Container(
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                      tag: 'buyPassport',
                      child: Image.network(
                        imageUrl,
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
                                  "Amrita Passport",
                                  style: GoogleFonts.quicksand(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(32)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Text(
                                  "₹ ${amount.toString()}",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: MarkdownBody(
                                data:
                                    "The Anokha passport serves as the exclusive entry ticket, granting access to the Anokha tech fest. All students, excluding those from Amrita Vishwa Vidyapeetham Coimbatore campus, must acquire a passport prior to event and workshop registration. Coimbatore campus students, however, need not purchase a passport but must register using their Amrita email-id. The passport, priced at ₹300 (including GST), ensures entry to the tech fest, while separate registration fees apply to events and workshops. Instead of physical copies, a QR code provided upon passport purchase must be presented for entry throughout the three days of the tech fest.",
                                styleSheet: MarkdownStyleSheet(
                                  h1: GoogleFonts.poppins(color: Colors.white),
                                  h2: GoogleFonts.poppins(color: Colors.white),
                                  h3: GoogleFonts.poppins(color: Colors.white),
                                  h4: GoogleFonts.poppins(color: Colors.white),
                                  h5: GoogleFonts.poppins(color: Colors.white),
                                  h6: GoogleFonts.poppins(color: Colors.white),
                                  a: GoogleFonts.poppins(color: Colors.white),
                                  p: GoogleFonts.poppins(color: Colors.white),
                                  code:
                                      GoogleFonts.poppins(color: Colors.white),
                                  em: GoogleFonts.poppins(color: Colors.white),
                                  strong:
                                      GoogleFonts.poppins(color: Colors.white),
                                  del: GoogleFonts.poppins(color: Colors.white),
                                  blockquote:
                                      GoogleFonts.poppins(color: Colors.white),
                                  img: GoogleFonts.poppins(color: Colors.white),
                                  checkbox:
                                      GoogleFonts.poppins(color: Colors.white),
                                  listBullet:
                                      GoogleFonts.poppins(color: Colors.white),
                                  tableHead:
                                      GoogleFonts.poppins(color: Colors.white),
                                  tableBody:
                                      GoogleFonts.poppins(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _buyPassport() async {
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
          Constants.buyPassport,
          options: Options(
            headers: {
              "Authorization": "Bearer $secretToken",
            },
            validateStatus: (status) => status! < 1000,
          ),
          data: {},
        );
        if (kDebugMode) {
          print("[BUY PASSPORT]: ${response.data}");
          print("[STATUS]: ${response.statusCode}");
        }
        if (response.statusCode == 200) {
          var transMap = response.data;
          debugPrint(transMap.toString());
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                        transData: transMap,
                      )));
        } else if (response.statusCode == 400 &&
            response.data["MESSAGE"] != null) {
          if (response.data["MESSAGE"] == "You Already have a passport!") {
            //todo: bug
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
            // nextScreenReplace(context, const UserProfile());
          }
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
              MaterialPageRoute(builder: (context) => const PrimaryScreen()),
              (route) => false);
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
        context,
        MaterialPageRoute(builder: (context) => const PrimaryScreen()),
        (route) => false);
  }
}
