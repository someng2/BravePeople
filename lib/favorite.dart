import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hgu_21_2_mobileappdevelopment/store.dart';
import 'package:hgu_21_2_mobileappdevelopment/store_detail.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('store')
            .where('client', arrayContains: FirebaseAuth.instance.currentUser!.email)
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
                title: const Text('내가 찜한 가게',
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
                            child: Image.network(
                              data['image'],
                              width: 80,
                              height: 100,
                            )),
                        title: Text(data['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['menu'][0],
                                  style: const TextStyle(fontSize: 11),
                                ),
                                const Text(
                                  ', ',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Text(
                                  data['menu'][1],
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(data['business_time']),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                StoreDetail.routeName,
                                arguments: Store_id(data['store_id'], data['latitude'], data['longitude'], data['name'], data['review_count'], data['address_gu'], data['address'], data['phone'], data['image'], data['star_sum']),
                              );
                            },
                            icon: const Icon(Icons.navigate_next)),
                      ),
                      const Divider(),
                    ],
                  );
                }).toList(),
              )
          );
        });
  }
}