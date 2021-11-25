import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'store_detail.dart';

class Store_id{
  final int store_id;

  Store_id(this.store_id);
}

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  // final int store_id;
  //
  // Store(this.store_id);

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
          body: TabBarView(
            children: [
              _buildTabBarView('한식'),
              _buildTabBarView('한식'),
              _buildTabBarView('한식'),
              _buildTabBarView('한식'),
              _buildTabBarView('한식'),
              _buildTabBarView('카페'),
            ],
          ),
        ));
  }
}

Widget _buildTabBarView(String category) {

  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('store')
          .where('category', isEqualTo: category)
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
            return Column(
              children: [
                ListTile(
                  leading: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 80, minHeight: 100),
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
                          Text(data['menu'][0], style: const TextStyle(fontSize: 11),),
                          const Text(',', style: TextStyle(fontSize: 11),),
                          Text(data['menu'][1], style: const TextStyle(fontSize: 11),),

                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(data['business_time']),
                    ],
                  ),
                  trailing: IconButton(onPressed: (){
                    Navigator.pushNamed(
                      context,
                      Store_Detail.routeName,
                      arguments: Store_id(
                        data['store_id']
                      ),
                    );
                  }, icon: const Icon(Icons.navigate_next)),
                ),
                const Divider(),
              ],

            );
          }).toList(),
        );
      });
}


