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
                  .where('status', isNotEqualTo: 'Rejected')
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
                            text: data.docs[index]['name'] +
                                ' - ' +
                                data.docs[index]['status'],
                            fontSize: 12),
                        subtitle: data.docs[index]['responder'] == ''
                            ? const SizedBox()
                            : StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(data.docs[index]['responder'])
                                    .snapshots(),
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
                                  dynamic data12 = snapshot.data;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: data.docs[index]['caption'],
                                        fontSize: 14,
                                        fontFamily: 'Bold',
                                      ),
                                      data.docs[index]['responder'] != ''
                                          ? TextWidget(
                                              text:
                                                  'Responder: ${data12['name']}',
                                              fontSize: 12,
                                              fontFamily: 'Medium',
                                            )
                                          : const SizedBox(),
                                      TextWidget(
                                        text: DateFormat.yMMMd()
                                            .add_jm()
                                            .format(data.docs[index]['dateTime']
                                                .toDate()),
                                        fontSize: 12,
                                        fontFamily: 'Bold',
                                      ),
                                    ],
                                  );
                                }),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: TextWidget(
                                    text:
                                        'Are you sure you want to reject this report?',
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
                                          'status': 'Rejected'
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: TextWidget(
                                        text: 'Continue',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
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
