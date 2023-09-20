import 'package:flutter/material.dart';
import 'package:responder/widgets/text_widget.dart';

class HazardTab extends StatelessWidget {
  const HazardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(
            Icons.info,
          ),
          title: TextWidget(
            text: 'Title of the Announcements',
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Bold',
          ),
          subtitle: TextWidget(
            text: 'Description of the Announcements',
            fontSize: 12,
            color: Colors.grey,
          ),
        );
      },
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
