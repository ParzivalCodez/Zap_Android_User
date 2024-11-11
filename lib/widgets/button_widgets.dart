// Dependencies & Packages Import
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {super.key, required this.buttonText, required this.buttonEvent});

  final String buttonText;
  final void Function() buttonEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonEvent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius:
              BorderRadius.circular(12), // Adjust the radius as needed
        ),
        child: Center(
          child: Text(
            buttonText,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ButtonSecondary extends StatelessWidget {
  const ButtonSecondary(
      {super.key, required this.buttonText, required this.buttonEvent});

  final String buttonText;
  final void Function() buttonEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonEvent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, // Border color
            width: 2.0, // Border width
          ),
          borderRadius:
              BorderRadius.circular(4.0), // Optional: for rounded corners
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
