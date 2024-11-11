// Dependencies & Packages Import
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/registration_services.dart';
import '../../widgets/button_widgets.dart';
import '../../widgets/onboarding/registration_input_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final userMailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: GoogleFonts.poppins(
                        fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod",
                    style: GoogleFonts.poppins(),
                  )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      RegistrationInputWidget(
                        inputType: TextInputType.name,
                        inputDecoration: 'Name',
                        textEditingController: nameController,
                      ),
                      const SizedBox(height: 30),
                      RegistrationInputWidget(
                        inputType: TextInputType.name,
                        inputDecoration: 'Phone Number',
                        textEditingController: phoneController,
                      ),
                      const SizedBox(height: 30),
                      RegistrationInputWidget(
                        inputType: TextInputType.name,
                        inputDecoration: 'Mail ID',
                        textEditingController: userMailController,
                      ),
                    ],
                  ),
                ),
              ),
              ButtonPrimary(
                buttonText: "Create Account",
                buttonEvent: () => registrationHandler(nameController.text,
                    phoneController.text, userMailController.text, context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
