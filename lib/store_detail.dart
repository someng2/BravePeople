import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'add_review.dart';

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
                                icon: Icon(Icons.favorite_border),
                                onPressed: () {}),
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
                                    ]),
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
                                          child: Text(data['detail'],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Text(
                                  '리뷰',
                                ),
                              ]),
                            ))
                      ]),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,20,20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AddReview.routeName,
                                    arguments: Store_id(
                                        data['store_id']
                                    ),
                                  );
                                },
                                child: const Icon(Icons.edit,),
                              backgroundColor: const Color(0xffc0e2af),
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
