import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addNotif(
    name, contactnumber, address, caption, imageURL, lat, long) async {
  final docUser = FirebaseFirestore.instance.collection('Notifs').doc();

  final json = {
    'name': name,
    'address': address,
    'caption': caption,
    'status': 'Crisis',
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'contactnumber': contactnumber,
    'imageURL': imageURL,
    'dateTime': DateTime.now(),
    'lat': lat,
    'long': long,
    'responder': ''
  };

  await docUser.set(json);
}
