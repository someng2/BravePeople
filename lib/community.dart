import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'community_detail.dart';

class Community_id {
  final int community_id;

  Community_id(this.community_id);
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '포항 이야기',
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
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.collection("community")
              .orderBy('created', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                String time = DateTime.now().millisecondsSinceEpoch.toString();
                //DateTime createdDate = DateTime.parse(data["created"].toDate());
                //String createdDateString = DateFormat.yMMMd('en_US').format(createdDate);
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffDBEE91),
                      border: Border.all(width: 10, color: Color(0xffdbee91)),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["title"],
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 20),
                              Row(children: [
                                Text(time),
                                const SizedBox(width: 100),
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.red,
                                ),
                                //Text(data["like"]),
                                const SizedBox(width: 30),
                                Icon(
                                  Icons.message,
                                  color: Colors.blue,
                                ),
                                //Text(data["comment"]),
                              ])
                            ]),
                        const SizedBox(width: 10),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, CommunityDetail.routeName,
                                arguments: Community_id(data['commmunity_id']),);
                            },
                            icon: const Icon(Icons.navigate_next)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'communityCreate');
        },
        child: const Icon(Icons.border_color),
        backgroundColor: Colors.green,
      ),
    );
  }
}
