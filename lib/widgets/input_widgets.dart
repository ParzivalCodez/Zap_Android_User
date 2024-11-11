import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget(this.firstWidget, this.secondWidget, {super.key});

  final Widget firstWidget;
  final Widget secondWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Border color
          width: 2.0, // Border width
        ),
      ),
      child: Row(
        children: [firstWidget, secondWidget],
      ),
    );
  }
}
