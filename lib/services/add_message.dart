import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addMessage(name, msg) async {
  final docUser = FirebaseFirestore.instance.collection('Message').doc();

  final json = {
    'name': name,
    'msg': msg,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
