import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:responder/screens/notif_screen.dart';
import 'package:responder/screens/tabs/main_map_tab.dart';
import 'package:responder/screens/tabs/newhazard_tab.dart';
import 'package:responder/screens/tabs/report_tab.dart';
import 'package:responder/services/add_message.dart';
import 'package:responder/services/add_notif.dart';
import 'package:responder/widgets/drawer_widget.dart';
import 'package:responder/widgets/text_widget.dart';
import 'package:responder/widgets/textfield_widget.dart';
import 'package:responder/widgets/toast_widget.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();
    getLocation();

    setState(() {
      hasLoaded = true;
    });
  }

  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'lat': position.latitude, 'long': position.longitude});
    });
  }

  bool hasLoaded = false;

  final reportController = TextEditingController();

  final msgController = TextEditingController();
  String msg = '';

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.health_and_safety_outlined,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                      'Emergency Confirmation',
                      style: TextStyle(
                          fontFamily: 'QBold', fontWeight: FontWeight.bold),
                    ),
                    content: SizedBox(
                      height: 100,
                      child: TextFieldWidget(
                        controller: reportController,
                        label: 'Name of Emergency Report',
                      ),
                    ),
                    actions: <Widget>[
                      MaterialButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                              fontFamily: 'QRegular',
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: userData,
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Something went wrong'));
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            dynamic data = snapshot.data;
                            return MaterialButton(
                              onPressed: () async {
                                addNotif(
                                    data['name'],
                                    data['contactnumber'],
                                    data['address'],
                                    'EMERGENCY REPORT ALERT: ${reportController.text}',
                                    'imageURL',
                                    0,
                                    0);

                                showToast('Emergency Alert Added!');
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Continue',
                                style: TextStyle(
                                    fontFamily: 'QRegular',
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }),
                    ],
                  ));
        },
      ),
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: TextWidget(
          text: 'HOME',
          fontSize: 18,
          color: Colors.white,
        ),
        centerTitle: true,
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Notifs').snapshots(),
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
                          builder: (context) => const NotifPage()));
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: TextWidget(
                      text: 'Chats',
                      fontSize: 18,
                      fontFamily: 'Bold',
                    ),
                    content: SizedBox(
                      height: 400,
                      width: 500,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Message')
                                    .orderBy('dateTime')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return const Center(child: Text('Error'));
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    print('waiting');
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.black,
                                      )),
                                    );
                                  }

                                  final data1 = snapshot.requireData;
                                  return SizedBox(
                                    height: 350,
                                    width: 500,
                                    child: ListView.builder(
                                      itemCount: data1.docs.length,
                                      itemBuilder: (context, index1) {
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.account_circle_outlined,
                                          ),
                                          title: TextWidget(
                                            text: data1.docs[index1]['msg'],
                                            fontSize: 14,
                                          ),
                                          subtitle: TextWidget(
                                            text: data1.docs[index1]['name'],
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                            TextFormField(
                              controller: msgController,
                              decoration: InputDecoration(
                                suffixIcon: StreamBuilder<DocumentSnapshot>(
                                    stream: userData,
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData) {
                                        return const SizedBox();
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                            child:
                                                Text('Something went wrong'));
                                      } else if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox();
                                      }
                                      dynamic data = snapshot.data;
                                      return IconButton(
                                        onPressed: () {
                                          if (msgController.text != '') {
                                            addMessage(data['name'],
                                                msgController.text);
                                            showToast('Message sent!');
                                            msgController.clear();
                                          } else {
                                            showToast('Please input a message');
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.send,
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: TextWidget(
                          text: 'Close',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(
              Icons.chat,
            ),
          ),
        ],
      ),
      body: hasLoaded
          ? children[_currentIndex]
          : const Center(
              child: CircularProgressIndicator(),
            ),
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

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
