import 'package:anokha/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


void main() => runApp(const PaymentSuccess());

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

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
            Center(
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
                  EdgeInsets.only(
                    left: MediaQuery.of(context).size.width*0.1,right: MediaQuery.of(context).size.width*0.1,top: MediaQuery.of(context).size.width*0.1,bottom: MediaQuery.of(context).size.width*0.05,),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'assets/json/transactionSuccess.json',
                        width: MediaQuery.of(context).size.width*0.5,
                        height: MediaQuery.of(context).size.width*0.5,
                      ),
                      Text(
                        "Payment Success",
                        style: GoogleFonts.nunito(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.all(
                            20),
                        child: MaterialButton(
                          onPressed: () {

                            // should go to event registration page

                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                              return HomePage();
                            }), (route) => false);
                            // TODO: route
                            // nextScreenReplace(context,EventsWorkshopsPage(isFeatured: false,));
                          },
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(25),
                          ),
                          minWidth: MediaQuery.of(context).size.width*0.1,
                          padding: const EdgeInsets
                              .symmetric(
                              horizontal: 12.0,
                              vertical: 8.0),
                          color: Color.fromARGB(
                              255, 8, 44, 68),
                          child: Text(
                            "Back to home",
                            style:
                            GoogleFonts.nunito(
                              fontSize: 15,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
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