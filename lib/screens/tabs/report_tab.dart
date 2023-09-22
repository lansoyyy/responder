import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Reports')
                  .where('status', isEqualTo: 'Pending')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('error');
                  return const Center(child: Text('Error'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.black,
                    )),
                  );
                }

                final data = snapshot.requireData;
                return Expanded(
                  child: ListView.builder(
                    itemCount: data.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: TextWidget(
                                  text:
                                      'Are you sure you want to respond to this report?',
                                  fontSize: 18,
                                  fontFamily: 'Bold',
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
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('Reports')
                                          .doc(data.docs[index].id)
                                          .update({
                                        'responder': FirebaseAuth
                                            .instance.currentUser!.uid,
                                        'status': 'Accepted'
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: TextWidget(
                                      text: 'Confirm',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        leading: const Icon(
                          Icons.account_circle,
                        ),
                        title: TextWidget(
                            text: data.docs[index]['name'], fontSize: 12),
                        subtitle: TextWidget(
                          text: data.docs[index]['caption'],
                          fontSize: 14,
                          fontFamily: 'Bold',
                        ),
                        trailing: TextWidget(
                          text: DateFormat.yMMMd()
                              .add_jm()
                              .format(data.docs[index]['dateTime'].toDate()),
                          fontSize: 12,
                          fontFamily: 'Bold',
                        ),
                      );
                    },
                  ),
                );
              })
        ],
      ),
    );
  }
}
