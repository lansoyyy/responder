import 'package:flutter/material.dart';
import 'package:responder/widgets/text_widget.dart';

class HazardTab extends StatelessWidget {
  const HazardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cardWidget('assets/images/report.png', '24'),
              cardWidget('assets/images/fire 1.png', '24'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cardWidget('assets/images/image 2.png', '24'),
              cardWidget('assets/images/flood.png', '24'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cardWidget('assets/images/earthquake.png', '24'),
              cardWidget('assets/images/landslide.png', '24'),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardWidget(String path, String number) {
    return Container(
      width: 175,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              path,
              height: 60,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: number,
              fontSize: 24,
              fontFamily: 'Bold',
            ),
          ],
        ),
      ),
    );
  }
}
