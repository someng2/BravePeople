import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'community_detail.dart';
import 'community_main.dart';

class Created {
  final String created;

  Created(this.created);
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);
  static const routeName = '/community';

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  TextEditingController searchController = TextEditingController();

  final TextEditingController _filter = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search, color: Colors.black);
  Widget _appBarTitle = Text('');
  List filteredNames = [];
  List names = [];
  String _searchText = "";

  bool searching = false;
  bool total = false;

  _CommunityState() {
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
    final args = ModalRoute.of(context)!.settings.arguments as Address;

    String location;
    if (args == null) {
      location = '포항';
      total = true;
    } else
      location = args.address;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          location + '이야기',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          if (!searching)
            IconButton(
              icon: _searchIcon,
              onPressed: () {
                _searchPressed();
              },
            ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: (searching
          ? _build(location, total, searching, _searchText)
          : _build(location, total, searching, _searchText)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/communityCreate');
        },
        child: const Icon(
          Icons.edit,
          color: Color(0xff13740B),
        ),
        backgroundColor: const Color(0xffC0E2AF),
      ),
    );
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
            hintText: '게시글 검색',
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

Widget _build(String location, bool total, bool searching, String _searchText) {
  return SizedBox(
    height: 800,
    child: StreamBuilder<QuerySnapshot>(
        stream: total
            ? (searching
                ? (FirebaseFirestore.instance
                    .collection('community')
                    .orderBy('created', descending: true)
                    .where('content', arrayContains: _searchText)
                    .snapshots())
                : (FirebaseFirestore.instance
                    .collection('community')
                    .orderBy('created', descending: true)
                    .snapshots()))
            : (searching
                ? (FirebaseFirestore.instance
                    .collection('community')
                    .orderBy('created', descending: true)
                    .where('content', arrayContains: _searchText)
                    .where('address', isEqualTo: location)
                    .snapshots())
                : (FirebaseFirestore.instance
                    .collection('community')
                    .orderBy('created', descending: true)
                    .where('address', isEqualTo: location)
                    .snapshots())),
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
              return Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xffDBEE91).withOpacity(0.5),
                    border: Border.all(
                        width: 10, color: Color(0xffC0E2AF).withOpacity(0.2)),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data["title"],
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data["content"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 20),
                              Row(children: [
                                Text(data["created"]),
                                const SizedBox(width: 60),
                                Icon(
                                  Icons.thumb_up,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text('${data["like"]}'),
                                const SizedBox(width: 20),
                                Icon(
                                  Icons.message,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 8),
                                Text('${data["comment"]}'),
                              ])
                            ]),
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              CommunityDetail.routeName,
                              arguments: Created(data['created']),
                            );
                          },
                          icon: const Icon(Icons.navigate_next)),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
  );
}
