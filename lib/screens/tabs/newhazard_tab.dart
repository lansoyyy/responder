import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responder/widgets/text_widget.dart';

class NewHazardTab extends StatelessWidget {
  bool? inNotif;

  NewHazardTab({
    super.key,
    this.inNotif = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardWidget('assets/images/report.png', 'Others'),
            cardWidget('assets/images/fire 1.png', 'Fire'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardWidget('assets/images/image 2.png', 'Hurricane'),
            cardWidget('assets/images/flood.png', 'Flood'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardWidget('assets/images/earthquake.png', 'Earthquake'),
            cardWidget('assets/images/landslide.png', 'Landslide'),
          ],
        ),
      ],
    );
  }

  Widget cardWidget(String path, String name) {
    return Container(
      width: 175,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Reports')
              .where('type', isEqualTo: name)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        height: 300,
                        width: 800,
                        child: ListView.builder(
                          itemCount: data.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: TextWidget(
                                  text: data.docs[index]['name'], fontSize: 12),
                              subtitle: TextWidget(
                                text: data.docs[index]['caption'],
                                fontSize: 14,
                                fontFamily: 'Bold',
                              ),
                              trailing: TextWidget(
                                text: DateFormat.yMMMd().add_jm().format(
                                    data.docs[index]['dateTime'].toDate()),
                                fontSize: 10,
                                fontFamily: 'Bold',
                              ),
                            );
                          },
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
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: name,
                      fontSize: 24,
                      fontFamily: 'Bold',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      path,
                      height: 50,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextWidget(
                      text: data.docs.length.toString(),
                      fontSize: 24,
                      fontFamily: 'Bold',
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
