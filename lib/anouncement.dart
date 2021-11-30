import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnouncementPage extends StatefulWidget {
  @override
  _AnouncementPageState createState() => _AnouncementPageState();
}

class _AnouncementPageState extends State<AnouncementPage> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('announcement')
            .orderBy('updateTime', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text('공지사항',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 0,
              ),
              body: ListView(
                  children:
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return SafeArea(
                      child: Column(
                        children: <Widget> [
                          Divider(
                              color: const Color(0xffC0E2AF).withOpacity(0.2),
                              thickness: 10.0),
                          ExpansionTile(
                              title: new Text(data['title'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black
                                ),
                              ),
                              initiallyExpanded: false,
                              backgroundColor: Colors.white,
                              children: <Widget>[
                                //Divider(height: 3,color: Colors.grey,),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  width: 300,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                    child: Wrap(
                                      children: [
                                        Text(data['message'],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //Divider(height: 3,color: Colors.grey,),
                              ]
                          ),
                        ],
                      ),
                    );
                  }).toList()));
        });
  }
}
