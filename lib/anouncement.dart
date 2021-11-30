import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnouncementPage extends StatefulWidget {
  @override
  _AnouncementPageState createState() => _AnouncementPageState();
}

class _AnouncementPageState extends State<AnouncementPage> {

  //int _value = 1;

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
              ),
              body: ListView(
                  children:
                  snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                    return SafeArea(
                      child: Column(
                        children: <Widget> [
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
                                Divider(height: 3,color: Colors.grey,),
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
                                            fontSize: 20,
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
      ),
      body: SafeArea(
        child: Column(
            children: <Widget> [
              ExpansionTile(
                title: new Text('2021 - 11 - 28 업데이트',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black
                  ),
                ),
                initiallyExpanded: false,
                backgroundColor: Colors.white,
                children: <Widget>[
                  Divider(height: 3,color: Colors.grey,),
                  Container(
                    height: 50,
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        children: [
                          Text('제휴점 추가',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
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
      ),
    );
  }
}

// class ListItem {
//   int value;
//   String name;
//
//   ListItem(this.value, this.name);
// }