import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responder/widgets/text_widget.dart';
import 'package:intl/intl.dart';

class HazardTab extends StatelessWidget {
  const HazardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('Announcements').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          return SizedBox(
            width: 400,
            height: 600,
            child: ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                    leading: const Icon(
                      Icons.info,
                    ),
                    title: TextWidget(
                      text: data.docs[index]['name'],
                      fontSize: 18,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                    subtitle: TextWidget(
                      text: data.docs[index]['desc'],
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    trailing: TextWidget(
                      text: DateFormat.yMMMd()
                          .add_jm()
                          .format(data.docs[index]['dateTime'].toDate()),
                      fontSize: 12,
                      color: Colors.grey,
                    ));
              },
            ),
          );
        });
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
