import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class Store_Detail extends StatefulWidget {
  const Store_Detail({Key? key}) : super(key: key);

  static const routeName = '/storeDetail';

  @override
  _Store_DetailState createState() => _Store_DetailState();
}

class _Store_DetailState extends State<Store_Detail> {
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
              appBar: AppBar(),
              body: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
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
                            bottom: const PreferredSize(
                              child: TabBar(
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
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TabBarView(children: [
                                // first tab bar view widget
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                        for (var menu in data['menu']) Text(menu),
                                        for (var price in data['price']) Text(price),
                                    ]),
                                // second tab bar view widget
                                Container(
                                  child: Text(data['detail'],
                                      style: TextStyle(fontSize: 15)),
                                ),
                                Row(children: [
                                  Text(
                                    '리뷰',
                                  ),
                                ]),
                              ]),
                            ))
                      ]),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        });
  }
}
