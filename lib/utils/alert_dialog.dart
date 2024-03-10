import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      required this.content,
      required this.actions});

  final double width;
  final String title;
  final String content;
  final double height;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: const Color.fromRGBO(11, 38, 59, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: const BorderSide(color: Colors.white)),
        title: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.quicksand(
                fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: width * 0.7,
              height: height * 0.05,
              child: Center(
                  child: Text(
                content,
                style: GoogleFonts.quicksand(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ))),
        ),
        actions: actions);
  }
}
