import 'package:flutter/material.dart';
import 'package:responder/screens/tabs/map2_tab.dart';
import 'package:responder/screens/tabs/map_tab.dart';

class MainMapTab extends StatelessWidget {
  const MainMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              labelStyle: TextStyle(color: Colors.black),
              tabs: [
                Tab(
                  text: 'Ongoing',
                ),
                Tab(
                  text: 'Finished',
                ),
              ]),
          SizedBox(),
          Expanded(
              child: TabBarView(children: [
            MapTab(),
            Map2Tab(),
          ]))
        ],
      ),
    );
  }
}
