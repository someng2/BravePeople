import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'add_review.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key}) : super(key: key);

  static const routeName = '/storeDetail';

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store_id;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('store')
            .where('store_id', isEqualTo: args.store_id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          // print('detail page!');
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 80,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0,
              ),
              body: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
                  int menu_length = data['menu'].length;

                  bool flag = false;

                  var userEmail = FirebaseAuth.instance.currentUser!.email;

                  for(var i = 0; i < data['client'].length; i++)
                  {
                    if(data['client'][i] == userEmail)
                    {
                      flag = true;
                    }
                  }

                  return Column(
                    children: [
                      Column(children: [
                        Text(
                          data['name'],
                          style: const TextStyle(fontSize: 30),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.star_outlined,
                                color: Colors.yellow,
                                size: 25,
                              ),
                            ]),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.green),
                            Text(data['phone']),
                            SizedBox(width: 110),
                            IconButton(
                                icon: flag ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
                                color: flag ? Colors.red : null,
                                onPressed: () {
                                  if(flag)
                                  {
                                    FirebaseFirestore.instance.collection('store').doc(document.id).update(
                                        {
                                          'client': FieldValue.arrayRemove([userEmail])
                                        }
                                    );
                                  }
                                  else {
                                    FirebaseFirestore.instance.collection('store').doc(document.id).update(
                                        {
                                          'client': FieldValue.arrayUnion([userEmail])
                                        }
                                    );
                                  }
                                }),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width,
                                minHeight: 200),
                            child: Image.network(
                              data['image'],
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                            )),

                        SizedBox(
                          height: 50,
                          child: AppBar(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            bottom: const PreferredSize(
                              child: TabBar(
                                labelColor: Colors.black,
                                indicatorColor: Color(0xffc0e2af),
                                tabs: [
                                  Tab(
                                    text: '메뉴',
                                  ),
                                  Tab(
                                    text: '정보',
                                  ),
                                  Tab(
                                    text: '리뷰',
                                  ),
                                ],
                              ),
                              preferredSize: Size.fromHeight(40),
                            ),
                          ),
                        ), // create widgets for each tab bar here
                        SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TabBarView(children: [
                                // first tab bar view widget
                                Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0; i < menu_length; i++)
                                        Row(children: [
                                          SizedBox(
                                            child: Text(data['menu'][i]),
                                            width: 200,
                                          ),
                                          //SizedBox(width: 150),
                                          Row(
                                            children: [
                                              Text(data['price'][i]),
                                              const Text('원')
                                            ],
                                          ),
                                        ]),
                                      Row(
                                          children: [
                                            Text ('위치 : '),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context, '/map', arguments: Store_id(data['store_id']),);
                                              },
                                              child: Icon(Icons.map, color: Color(0xff13740B)),
                                              style: ElevatedButton.styleFrom(shape: StadiumBorder(),primary: Color(0xffC0E2AF)),
                                            )
                                          ]
                                      )
                                    ]
                                ),

                                // second tab bar view widget
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('주소: '),
                                        Text(data['address_gu']),
                                        const Text(' '),
                                        Text(data['address']),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('영업시간: '),
                                        Text(data['business_time']),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        const Text('* '),
                                        Flexible(
                                          child: Text(
                                            data['detail'],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // third tab bar
                                StreamBuilder<QuerySnapshot> (

                                    stream: FirebaseFirestore.instance
                                        .collection('review')
                                        .where('store_id',
                                        isEqualTo: args.store_id)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Something went wrong');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text("Loading");
                                      }
                                      return ListView(
                                        children: snapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;

                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Image.network('https://st4.depositphotos.com/1156795/20814/v/950/depositphotos_208142514-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(data['nickname']),
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
                                                ],
                                              ),
                                              const SizedBox(height: 10),
                                              if (!data['noImage'])
                                                Center(
                                                  child: Container(
                                                      width: 200,
                                                      child: Image.network(
                                                          data['imageUrl'],
                                                          fit: BoxFit.contain)

                                                  ),

                                                ),
                                              const SizedBox(height: 10),

                                              Text(data['content'], style: TextStyle(fontSize: 17)),
                                              const Divider(thickness: 2,),

                                            ],
                                          );
                                        }).toList(),
                                      );
                                    }),
                              ]),
                            ))
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  AddReview.routeName,
                                  arguments: Store_id(data['store_id']),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Color(0xff13740B),
                              ),
                              backgroundColor: const Color(0xffC0E2AF),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}