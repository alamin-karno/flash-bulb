import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CopyRightTextWidget extends StatelessWidget {
  const CopyRightTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "©Design & Build by Md. Al-Amin\nInspire from Ahmad Nasir",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
