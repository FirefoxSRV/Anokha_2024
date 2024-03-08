import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


class Verifying extends StatelessWidget {
  final txnId;

  const Verifying({super.key,required this.txnId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 8, 44, 68),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.1),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius
                        .all(
                        Radius.circular(
                            MediaQuery.of(context).size.width*0.08)),
                    color: Colors.white,),

                  child: Padding(
                    padding:
                    const EdgeInsets.all(
                        20.0),
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/json/transactionVerifying.json',
                          width: MediaQuery.of(context).size.width*0.5,
                          height: MediaQuery.of(context).size.width*0.5,
                        ),
                        Text(
                          "Verifying Payment",
                          style: GoogleFonts.nunito(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text.rich(TextSpan(
                          text: "Your Transaction ID is ",
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: txnId,
                              style: TextStyle(
                                color: Color.fromARGB(255, 8, 44, 68),
                                fontWeight:FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "\nPlease do not close this page",
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )),
                        SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}