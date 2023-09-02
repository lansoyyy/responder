import 'package:flutter/material.dart';
import 'package:responder/widgets/text_widget.dart';

import 'button_widget.dart';

class DialogWidget extends StatelessWidget {
  final String title;
  final Widget description;
  final String? buttonLabel;
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;
  final Color? titleColor;
  const DialogWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.icon,
      required this.onPressed,
      this.buttonLabel = 'Continue',
      this.iconColor = Colors.amber,
      this.titleColor = Colors.amber});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 125,
            ),
            TextWidget(
              text: title,
              fontSize: 24,
              fontFamily: 'Bold',
              color: titleColor,
            ),
            const SizedBox(
              height: 10,
            ),
            description,
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(width: 225, label: buttonLabel!, onPressed: onPressed),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
