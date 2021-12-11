import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'add_review.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class StoreDetail extends StatefulWidget {
  const StoreDetail({Key? key}) : super(key: key);

  static const routeName = '/storeDetail';

  @override
  _StoreDetailState createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  Color new_color = Colors.black;
  bool new_pushed = false;

  Color good_color = Colors.grey;
  bool good_pushed = true;

  Color bad_color = Colors.grey;
  bool bad_pushed = false;

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

                  String star_avg = '';

                  if (data['review_count'] > 0) {
                    star_avg = (data['star_sum'] / data['review_count'])
                        .toStringAsFixed(1);
                  }

                  for (var i = 0; i < data['client'].length; i++) {
                    if (data['client'][i] == userEmail) {
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
                        const SizedBox(height: 5),
                        if (data['review_count'] != 0)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 25,
                                ),
                                Text(
                                  star_avg,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ]),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 7),
                            Text(data['phone']),
                            SizedBox(width: 110),
                            IconButton(
                                icon: flag
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                                color: flag ? Colors.red : null,
                                onPressed: () {
                                  if (flag) {
                                    FirebaseFirestore.instance
                                        .collection('store')
                                        .doc(document.id)
                                        .update({
                                      'client':
                                          FieldValue.arrayRemove([userEmail])
                                    });
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection('store')
                                        .doc(document.id)
                                        .update({
                                      'client':
                                          FieldValue.arrayUnion([userEmail])
                                    });
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
                                indicatorWeight: 3,
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
                            child: TabBarView(
                              children: [
                                // first tab bar view widget
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (int i = 0; i < menu_length; i++)
                                        Column(
                                          children: [
                                            Row(children: [
                                              SizedBox(
                                                width: 170,
                                                child: Row(
                                                  children: [
                                                    const Text('▪︎'),
                                                    Text(
                                                      data['menu'][i],
                                                      // softWrap: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(children: [
                                                Text(
                                                  data['price'][i],
                                                  softWrap: true,
                                                ),
                                                const Text('원')
                                              ]),
                                            ]),
                                            SizedBox(height: 10),
                                          ],
                                        )
                                    ]),

                                // second tab bar view widget
                                Column(
                                  children: [
                                    Expanded(
                                      child: ListView(children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on),
                                                Text(data['address_gu']),
                                                const Text(' '),
                                                Text(data['address']),
                                                const SizedBox(width: 30),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    20,
                                                height: 50,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/map',
                                                      arguments: Store_id(
                                                          data['store_id'],
                                                          data['latitude'],
                                                          data['longitude'],
                                                          data['name'],
                                                          data['review_count'],
                                                          data['address_gu'],
                                                          data['address'],
                                                          data['phone'],
                                                          data['image'],
                                                          data['star_sum']),
                                                    );
                                                  },
                                                  // child: const Icon(Icons.map,
                                                  //     color: Color(0xff13740B)),
                                                  child: Stack(children: [
                                                    Image.asset(
                                                        'assets/map2.png',
                                                        fit: BoxFit.fitWidth),
                                                    Positioned(
                                                        child: Text(
                                                          '지도 보기',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4)),
                                                        ),
                                                        bottom: 15,
                                                        left: 100)
                                                  ]),
                                                  style: ElevatedButton.styleFrom(
                                                      // shape: const StadiumBorder(),
                                                      primary: Colors.white),
                                                ),
                                              ),
                                            ]),
                                            const SizedBox(height: 15),
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time),
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
                                      ]),
                                    ),
                                  ],
                                ),

                                // third tab bar
                                StreamBuilder<QuerySnapshot>(
                                    stream: (new_pushed
                                        ? FirebaseFirestore.instance
                                            .collection('review')
                                            .where('store_id',
                                                isEqualTo: args.store_id)
                                            .orderBy('created',
                                                descending: true)
                                            .snapshots()
                                        : (good_pushed
                                            ? FirebaseFirestore.instance
                                                .collection('review')
                                                .where('store_id',
                                                    isEqualTo: args.store_id)
                                                .orderBy('star',
                                                    descending: true)
                                                .snapshots()
                                            : FirebaseFirestore.instance
                                                .collection('review')
                                                .where('store_id',
                                                    isEqualTo: args.store_id)
                                                .orderBy('star',
                                                    descending: false)
                                                .snapshots())),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return const Text(
                                            'Something went wrong');
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text("Loading");
                                      }

                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    new_pushed = true;
                                                    good_pushed = false;
                                                    bad_pushed = false;
                                                  });
                                                },
                                                child: Text('최신순',
                                                    style: TextStyle(
                                                        color: (new_pushed
                                                            ? Colors.black
                                                            : Colors.grey))),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    good_pushed = true;
                                                    new_pushed = false;
                                                    bad_pushed = false;
                                                  });
                                                },
                                                child: Text('별점 높은순',
                                                    style: TextStyle(
                                                        color: good_pushed
                                                            ? Colors.black
                                                            : Colors.grey)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    bad_pushed = true;
                                                    new_pushed = false;
                                                    good_pushed = false;
                                                  });
                                                },
                                                child: Text('별점 낮은순',
                                                    style: TextStyle(
                                                        color: bad_pushed
                                                            ? Colors.black
                                                            : Colors.grey)),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: ListView(
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> data =
                                                    document.data()!
                                                        as Map<String, dynamic>;

                                                int Created_i =
                                                    int.parse(data['created']);
                                                var Created_d = DateFormat(
                                                        'yy/MM/dd HH:mm:ss')
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            Created_i));

                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipOval(
                                                          child: Image.network(
                                                            'https://st4.depositphotos.com/1156795/20814/v/950/depositphotos_208142514-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                                                            width: 40,
                                                            height: 40,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(data[
                                                                'nickname']),
                                                            Row(children: [
                                                              for (int i = 0;
                                                                  i <
                                                                      data[
                                                                          'star'];
                                                                  i++)
                                                                const Icon(
                                                                  Icons
                                                                      .star_outlined,
                                                                  color: Colors
                                                                      .yellow,
                                                                  size: 22,
                                                                )
                                                            ])
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            const SizedBox(
                                                                width: 20),
                                                            Text(Created_d),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    if (!data['noImage'])
                                                      Center(
                                                        child: SizedBox(
                                                            width: 200,
                                                            child: Image.network(
                                                                data[
                                                                    'imageUrl'],
                                                                fit: BoxFit
                                                                    .contain)),
                                                      ),
                                                    const SizedBox(height: 10),
                                                    Text(data['content'],
                                                        style: const TextStyle(
                                                            fontSize: 15)),
                                                    const Divider(
                                                      thickness: 2,
                                                    ),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                              ],
                            ),
                          ),
                        )
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
                                  arguments: Store_id(
                                      data['store_id'],
                                      data['latitude'],
                                      data['longitude'],
                                      data['name'],
                                      data['review_count'],
                                      data['address_gu'],
                                      data['address'],
                                      data['phone'],
                                      data['image'],
                                      data['star_sum']),
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
