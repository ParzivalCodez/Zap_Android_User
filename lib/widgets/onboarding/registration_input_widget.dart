import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationInputWidget extends StatefulWidget {
  const RegistrationInputWidget(
      {super.key,
      required this.inputDecoration,
      required this.inputType,
      required this.textEditingController});

  final String inputDecoration;
  final TextInputType inputType;
  final TextEditingController textEditingController;

  @override
  State<RegistrationInputWidget> createState() =>
      _RegistrationInputWidgetState();
}

class _RegistrationInputWidgetState extends State<RegistrationInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.inputDecoration,
          style: GoogleFonts.poppins(fontSize: 25),
        ),
        const SizedBox(height: 10),
        Container(
          color: const Color.fromARGB(255, 211, 211, 211),
          child: TextField(
            keyboardType: widget.inputType,
            controller: widget.textEditingController,
            decoration: const InputDecoration(
              border: InputBorder.none, // Removes the border
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        )
      ],
    );
  }
}
