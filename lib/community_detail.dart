import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'community.dart';

class CommunityDetail extends StatefulWidget {
  const CommunityDetail({Key? key}) : super(key: key);

  static const routeName = '/communityDetail';

  @override
  _CommunityDetailState createState() => _CommunityDetailState();
}

class _CommunityDetailState extends State<CommunityDetail> {
  TextEditingController commentController = TextEditingController();

  String created = DateFormat('yyyy-MM-dd - HH:mm').format(DateTime.now());
  String write = "";
  String nickname = "";
  String title = "";

  bool _alreadyLiked = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Created;

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        nickname = doc['nickname'];
      });
    });

    FirebaseFirestore.instance
        .collection('community')
        .where('created', isEqualTo: args.created)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        title = doc['title'];
      });
    });

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
        resizeToAvoidBottomInset: false,
        body: Column(children: [
          SizedBox(
            height: 400,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('community')
                    .where('created', isEqualTo: args.created)
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
                                    Column(
                                      children: [
                                        Text(data['nickname'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(data['address']),
                                        const SizedBox(width: 30),
                                        Text(data['created']),
                                      ],
                                    ),
                                    const SizedBox(width: 80),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_alreadyLiked == false) {
                                            _alreadyLiked = true;
                                            FirebaseFirestore.instance.collection("community").doc('$title').update({
                                              "like": FieldValue.increment(1),
                                            });
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        _alreadyLiked
                                            ? Icons.thumb_up
                                            : Icons.thumb_up_outlined,
                                        size: 50,
                                        color: Colors.red,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      '${data["like"]}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('제목: ' + data['title'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 20),
                                      Text(data['content']),
                                      const SizedBox(height: 50),
                                      if(data['noImage'] == false)
                                        Image.network(
                                          data['imageUrl'],
                                          width: 80,
                                          height: 100,
                                        )
                                    ],
                                  )),
                            ),
                          ]);
                    }).toList(),
                  );
                }),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 50,
              width: 300,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xffDBEE91).withOpacity(0.3),
                  hintText: ('댓글을 작성하세요'),
                  contentPadding:
                      const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
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
                FirebaseFirestore.instance.collection("comment").doc().set({
                  "content": write,
                  "created": created,
                  "nickname": nickname,
                  "title": title,
                  'uid': FirebaseAuth.instance.currentUser!.uid,
                });
                FirebaseFirestore.instance.collection("community").doc('$title').update({
                  "comment": FieldValue.increment(1),
                });
                commentController.clear();
              },
              color: Color(0xffC0E2AF),
            ),
          ]),
          SizedBox(
            height: 350,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('comment')
                    .where('title', isEqualTo: title)
                    .orderBy('created', descending: true)
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
                          margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Color(0xffDBEE91).withOpacity(0.6),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(8)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['nickname'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(data['content']),
                              const SizedBox(height: 8),
                              Text(data['created']),
                            ],
                          ));
                    }).toList(),
                  );
                }),
          ),
        ]));
  }
}
