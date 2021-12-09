import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'store_detail.dart';

class Store_id {
  final int store_id;
  final double latitude;
  final double longitude;
  final String name;
  final int review_count;
  final String address_gu;
  final String address;
  final String phone;
  final String image;
  final int star_sum;

  Store_id(this.store_id, this.latitude, this.longitude, this.name, this.review_count, this.address_gu, this.address, this.phone, this.image, this.star_sum);
}


class Store extends StatefulWidget {
  const Store({Key? key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final List<String> valueList = ['북구・남구', '북구', '남구'];
  String dropdownValue = '북구・남구';
  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = Text('Search Example');
  List filteredNames = [];
  List names = [];
  String _searchText = "";

  bool total = true;
  bool Bukgu = true;
  bool searching = false;

  _StoreState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!(_searchText.isEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
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
                title: _appBarTitle,
                actions: <Widget>[
                  if (!searching)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                            color: const Color(0xffc0e2af),
                            style: BorderStyle.solid,
                            width: 4),
                      ),
                      height: 10,
                      width: 112,
                      margin: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_downward,
                                color: Color(0xffc0e2af)),
                            iconSize: 22,
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
                    ),
                  IconButton(
                    icon: _searchIcon,
                    onPressed: () {
                      _searchPressed();
                    },
                  ),
                ],
                // if (searching)
                bottom: (searching
                    ? const PreferredSize(
                    preferredSize: Size.fromHeight(10),
                    child: SizedBox(
                      height: 10,
                    ))
                    : const PreferredSize(
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
                ))),
            body: (searching
                ? _buildTabBarView('no', Bukgu, total, searching, _searchText)
                : TabBarView(
              children: [
                _buildTabBarView(
                    '한식', Bukgu, total, searching, _searchText),
                _buildTabBarView(
                    '양식', Bukgu, total, searching, _searchText),
                _buildTabBarView(
                    '중식', Bukgu, total, searching, _searchText),
                _buildTabBarView(
                    '일식', Bukgu, total, searching, _searchText),
                _buildTabBarView(
                    '분식', Bukgu, total, searching, _searchText),
                _buildTabBarView(
                    '카페', Bukgu, total, searching, _searchText),
              ],
            ))));
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        searching = true;
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _filter,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search, color: Color(0xffc0e2af)),
            hintText: '메뉴 검색',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffc0e2af), width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffc0e2af), width: 2),
            ),
          ),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        searching = false;
        _appBarTitle = const Text('');
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}

Widget _buildTabBarView(String category, bool Bukgu, bool total, bool searching,
    String _searchText) {
  return StreamBuilder<QuerySnapshot>(
      stream: total
          ? (searching
          ? (FirebaseFirestore.instance
          .collection('store')
      // .where('name', isEqualTo: _searchText)
          .where('menu', arrayContains: _searchText)
          .snapshots())
          : (FirebaseFirestore.instance
          .collection('store')
          .where('category', isEqualTo: category)
          .snapshots()))
          : (searching
          ? (FirebaseFirestore.instance
          .collection('store')
          .where('menu', arrayContains: _searchText)
          .where('address_gu', isEqualTo: (Bukgu ? '북구' : '남구'))
          .snapshots())
          : FirebaseFirestore.instance
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

            String menu1 = data['menu'][0];
            String menu2 = data['menu'][1];
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
                      Text(
                        '$menu1 , $menu2',
                        softWrap: true,
                        // maxLines: 1,
                        style: const TextStyle(fontSize: 12),
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
                const Divider(
                  thickness: 1,
                ),
              ],
            );
          }).toList(),
        );
      });
}
