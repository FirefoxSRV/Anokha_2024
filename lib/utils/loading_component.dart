import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingComponent extends StatelessWidget {
  const LoadingComponent({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}