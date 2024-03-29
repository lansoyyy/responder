import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    determinePosition();

    getMyReports();
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        hasloaded = true;
      });
    }).catchError((error) {
      print('Error getting location: $error');
    });
  }

  bool hasloaded = false;
  double lat = 0;
  double long = 0;
  GoogleMapController? mapController;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};
  Set<Polyline> poly = {};

  // addMarker(userData) async {
  //   markers.add(Marker(
  //     markerId: MarkerId(userData.id),
  //     icon: BitmapDescriptor.defaultMarker,
  //     position: LatLng(userData['lat'], userData['long']),
  //     infoWindow: InfoWindow(
  //       title: 'Caption: ${userData['caption']}',
  //       snippet: 'Reporter Name: ${userData['name']}',
  //     ),
  //   ));

  //   poly.add(
  //     Polyline(
  //         color: Colors.red,
  //         width: 2,
  //         points: [
  //           LatLng(lat, long),
  //           LatLng(userData['lat'], userData['long']),
  //         ],
  //         polylineId: PolylineId(userData.id)),
  //   );
  //   setState(() {});
  // }

  List ids = [];

  getMyReports() async {
    FirebaseFirestore.instance
        .collection('Reports')
        .where('status', isEqualTo: 'Accepted')
        .where('responder', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        setState(() {
          ids.add(doc['userId']);
        });
      }
    }).whenComplete(() => getReporterLocation());
  }

  getReporterLocation() async {
    for (int i = 0; i < ids.length; i++) {
      Timer.periodic(const Duration(seconds: 5), (timer) {
        FirebaseFirestore.instance
            .collection('Users')
            .where('userId', isEqualTo: ids[i])
            .get()
            .then((QuerySnapshot querySnapshot) async {
          for (var doc in querySnapshot.docs) {
            setState(() {
              markers.clear();

              poly.clear();
              markers.add(Marker(
                markerId: MarkerId(doc['userId']),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(doc['lat'], doc['long']),
                infoWindow: InfoWindow(
                  title: 'Address: ${doc['address']}',
                  snippet: 'Reporter Name: ${doc['name']}',
                ),
              ));

              poly.add(
                Polyline(
                    color: Colors.red,
                    width: 2,
                    points: [
                      LatLng(lat, long),
                      LatLng(doc['lat'], doc['long']),
                    ],
                    polylineId: PolylineId(doc['userId'])),
              );
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition kGooglePlex = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.4746,
    );
    return hasloaded
        ? GoogleMap(
            polylines: poly,
            myLocationEnabled: true,
            markers: markers,
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
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
