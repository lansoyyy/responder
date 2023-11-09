import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responder/screens/notif_screen.dart';
import 'package:responder/screens/tabs/hazard_tab.dart';
import 'package:responder/screens/tabs/main_map_tab.dart';
import 'package:responder/screens/tabs/map_tab.dart';
import 'package:responder/screens/tabs/newhazard_tab.dart';
import 'package:responder/screens/tabs/report_tab.dart';
import 'package:responder/widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> children = [
    NewHazardTab(),
    const ReportTab(),
    const MainMapTab(),
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
          text: 'HOME',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Reports')
                  .where('status', isEqualTo: 'Pending')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('waiting');
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NotifScreen()));
                    },
                    child: Badge(
                      backgroundColor: Colors.red,
                      label: TextWidget(
                        text: data.docs.length.toString(),
                        fontSize: 12,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                      ),
                    ),
                  ),
                );
              }),
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
