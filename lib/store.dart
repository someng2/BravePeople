import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'store_detail.dart';

class Store_id {
  final int store_id;

  Store_id(this.store_id);
}

class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<String> valueList = ['북구・남구', '북구', '남구'];
  String dropdownValue = '북구・남구';

  bool total = true;
  bool Bukgu = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 55,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            // foregroundColor: Colors.black,
            actions: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                      color: const Color(0xffc0e2af),
                      style: BorderStyle.solid,
                      width: 4),
                ),
                height: 10,
                width: 105,
                // alignment: Alignment.center,
                margin: EdgeInsets.all(3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 20,
                      style: const TextStyle(color: Colors.black),
                      alignment: Alignment.center,
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                          if (dropdownValue == '북구・남구') {
                            total = true;
                          } else {
                            total = false;
                            if (dropdownValue == '남구') {
                              Bukgu = false;
                            } else {
                              Bukgu = true;
                            }
                          }
                        });
                      },
                      items: <String>['북구・남구', '북구', '남구']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            ],
            bottom: const PreferredSize(
              child: TabBar(
                  isScrollable: true,
                  indicatorColor: Color(0xffc0e2af),
                  //unselectedLabelColor: Color(0x00c0e2af),
                  labelColor: Colors.black,
                  tabs: [
                    Tab(
                      text: '한식',
                    ),
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
              _buildTabBarView('한식', Bukgu, total),
              _buildTabBarView('양식', Bukgu, total),
              _buildTabBarView('중식', Bukgu, total),
              _buildTabBarView('일식', Bukgu, total),
              _buildTabBarView('분식', Bukgu, total),
              _buildTabBarView('카페', Bukgu, total),
            ],
          ),
        ));
  }
}

Widget _buildTabBarView(String category, bool Bukgu, bool total) {
  return StreamBuilder<QuerySnapshot>(
      stream: total
          ? (FirebaseFirestore.instance
              .collection('store')
              .where('category', isEqualTo: category)
              .snapshots())
          : (FirebaseFirestore.instance
              .collection('store')
              .where('category', isEqualTo: category)
              .where('address_gu', isEqualTo: (Bukgu ? '북구' : '남구'))
              .snapshots()),
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
                          arguments: Store_id(data['store_id']),
                        );
                      },
                      icon: const Icon(Icons.navigate_next)),
                ),
                const Divider(),
              ],
            );
          }).toList(),
        );
      });
}
