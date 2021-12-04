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
                int comment_l = data["comment"].length;
                return Card(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffDBEE91).withOpacity(0.5),
                      border: Border.all(width: 10, color: Color(0xffC0E2AF).withOpacity(0.2)),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data["title"],
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  data["content"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 20),
                                Row(children: [
                                  Text(data["created"]),
                                  const SizedBox(width: 60),
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(data["like"]),
                                  const SizedBox(width: 20),
                                  Icon(
                                    Icons.message,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('$comment_l'),
                                ])
                              ]),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                CommunityDetail.routeName,
                                arguments: Community_id(data['community_id']),);
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
          Navigator.pushNamed(context, '/communityCreate');
        },
        child: const Icon(
          Icons.edit,
          color: Color(0xff13740B),
        ),
        backgroundColor: const Color(0xffC0E2AF),
      ),
    );
  }
}
