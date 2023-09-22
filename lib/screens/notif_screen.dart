import 'package:flutter/material.dart';
import 'package:responder/screens/tabs/hazard_tab.dart';

import '../widgets/text_widget.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextWidget(
          text: 'Notifications',
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      body: HazardTab(
        inNotif: true,
      ),
    );
  }
}
