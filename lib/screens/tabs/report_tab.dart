import 'package:flutter/material.dart';
import 'package:responder/widgets/text_widget.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Viewing Reports',
            fontSize: 18,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.account_circle,
                  ),
                  title: TextWidget(text: 'johndoe@gmail.com', fontSize: 12),
                  subtitle: TextWidget(
                    text: 'There is a big fire we need help',
                    fontSize: 14,
                    fontFamily: 'Bold',
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.delete,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
