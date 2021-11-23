import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            bottom: const PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: '한식'),
                    Tab(text: '아시안・양식'),
                    Tab(text: '중식'),
                    Tab(text: '일식'),
                    Tab(text: '분식'),
                    Tab(text: '카페・디저트'),
                  ]),
              preferredSize: Size.fromHeight(40),
            ),
          ),
          body: const TabBarView(
            children: [
              HanSik(),
              HanSik(),
              HanSik(),
              HanSik(),
              HanSik(),
              Cafe(),
            ],
          ),
        ));
  }
}

class HanSik extends StatefulWidget {
  const HanSik({Key? key}) : super(key: key);

  @override
  _HanSikState createState() => _HanSikState();
}

class _HanSikState extends State<HanSik> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('store')
            .where('category', isEqualTo: '한식')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              return ListTile(
                leading: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 100, minHeight: 100),
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
                        Text(data['menu'][0]),
                        Text(','),
                        Text(data['menu'][1]),

                      ],
                    ),
                    SizedBox(height: 10),
                    Text(data['business_time']),
                  ],
                ),
              );
            }).toList(),
          );
        });
  }
}

class Cafe extends StatefulWidget {
  const Cafe({Key? key}) : super(key: key);

  @override
  _CafeState createState() => _CafeState();
}

class _CafeState extends State<Cafe> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('store')
            .where('category', isEqualTo: '카페')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              return ListTile(
                leading: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 100, minHeight: 100),
                    child: Image.network(
                      data['image'],
                      width: 100,
                      height: 100,
                    )),
                title: Text(data['name']),
                subtitle: Text(data['category']),
                isThreeLine: true,
              );
            }).toList(),
          );
        });
  }
  
}

