import 'package:flutter/material.dart';
import 'package:responder/screens/tabs/hazard_tab.dart';
import 'package:responder/screens/tabs/map_tab.dart';
import 'package:responder/screens/tabs/report_tab.dart';
import 'package:responder/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> children = [
    const HazardTab(),
    const ReportTab(),
    const MapTab(),
  ];

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.account_circle_outlined,
        ),
        title: TextWidget(
          text: 'HAZARD ACTIVITY',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.notifications_rounded,
          ),
        ],
      ),
      body: children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontFamily: 'Bold'),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Bold'),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'HAZARD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'REPORTS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_sharp),
            label: 'MAP',
          ),
        ],
      ),
    );
  }
}
