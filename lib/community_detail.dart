import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'community.dart';

class CommunityDetail extends StatefulWidget {
  const CommunityDetail({Key? key}) : super(key: key);

  static const routeName = '/communityDetail';

  @override
  _CommunityDetailState createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Community_id;

    TextEditingController commentController = TextEditingController();
    String created = DateFormat('yyyy-MM-dd - HH:mm').format(DateTime.now());

    String write = "";

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('community')
            .where('community_id', isEqualTo: args.community_id)
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
              elevation: 0,
            ),
            body: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                List<dynamic> comment = data['comment'];
                List<dynamic> comment_nickname = data['comment_nickname'];
                List<dynamic> comment_time = data['comment_time'];

                int comment_length = data['comment'].length;

                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 50,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['nickname'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(data['address']),
                                    const SizedBox(width: 30),
                                    Text(data['created']),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 80),
                              Icon(
                                Icons.thumb_up,
                                size: 40,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 20),
                              Text(
                                data["like"],
                                style: const TextStyle(fontSize: 30),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 300,
                        width: 400,
                        child: Container(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xffC0E2AF).withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('제목: ' + data['title'],
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 30),
                                Text(data['content']),
                              ],
                            )),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 300,
                              child: TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffDBEE91).withOpacity(0.3),
                                  hintText: ('댓글을 작성하세요'),
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffDBEE91).withOpacity(0.7),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffDBEE91),
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                controller: commentController,
                                onChanged: (value) {
                                  setState(() {
                                    write = value;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection("community")
                                    .doc()
                                    .set({
                                  "comment": write,
                                  "comment_time": created,
                                });
                              },
                              color: Color(0xffC0E2AF),
                            ),
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < comment_length; i++)
                              SizedBox(
                                height: 100,
                                width: 400,
                                child: Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xffDBEE91).withOpacity(0.6),
                                      borderRadius: const BorderRadius.all(
                                          const Radius.circular(8)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(comment_nickname[i],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(comment[i]),
                                        Text(comment_time[i]),
                                      ],
                                    )),
                              ),
                          ]),
                    ]);
              }).toList(),
            ),
          );
        });
  }
}
