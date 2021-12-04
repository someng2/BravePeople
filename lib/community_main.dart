import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';

class CommunityMain extends StatefulWidget {
  const CommunityMain({Key? key}) : super(key: key);

  @override
  _CommunityMainState createState() => _CommunityMainState();
}

class _CommunityMainState extends State<CommunityMain> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '커뮤니티',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xffC0E2AF).withOpacity(0.5),
            borderRadius: const BorderRadius.all(const Radius.circular(8)),
          ),
          child: SizedBox(
            child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.collection("community")
                    .orderBy('like', descending: true)
                    .limit(2)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Container(
                        child: Row(
                          children: [
                            Text('포항이야기'),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
          )),
    );
  }
}
