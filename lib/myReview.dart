import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hgu_21_2_mobileappdevelopment/store.dart';
import 'package:hgu_21_2_mobileappdevelopment/store_detail.dart';

class MyReviewPage extends StatefulWidget {
  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {


  String nickname = '';


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('review')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
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
                title: const Text('나의 리뷰',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                elevation: 3,
              ),
              body: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
                  return Column(
                    children: [
                      ListTile(
                        leading: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 80, minHeight: 100),
                            child: data['noImage'] ? Image.network(
                              data['store_image'],
                              width: 80,
                              height: 80,
                            )
                                : ClipOval(
                              child: Image.network('https://st4.depositphotos.com/1156795/20814/v/950/depositphotos_208142514-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                                width: 80,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )),
                        title: Text(data['store_name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['content'],
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 10),
                            Row(
                                children: [
                                  for(int i = 0; i < data['star']; i++)
                                    const Icon(Icons.star_outlined,
                                      color: Colors.yellow,
                                      size: 22,)
                                ]
                            )
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                StoreDetail.routeName,
                                arguments: Store_id(data['store_id'], 0.0, 0.0, "", 0, "", "", "", "", 0),
                              );
                            },
                            icon: const Icon(Icons.navigate_next)),
                      ),
                      const Divider(thickness: 1,),
                    ],
                  );
                }).toList(),
              )
          );
        });
  }
}
