import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CommunityCreate extends StatefulWidget {
  @override
  _CommunityCreateState createState() => _CommunityCreateState();
}

class _CommunityCreateState extends State<CommunityCreate> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  Future totalLength() async {
    var count = await FirebaseFirestore.instance
        .collection('community')
        .snapshots()
        .length
        .toString;
    return count;
  }

  final List<String> comment = [];
  final List<String> comment_nickname = [];
  final List<String> comment_time = [];
  final String like = '0';

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String title = "";
  String content = "";
  String created = DateFormat('yyyy-MM-dd - HH:mm').format(DateTime.now());

  final List<String> location = ['북구', '남구'];
  String address = '북구';
  bool location_north = true;

  @override
  Widget build(BuildContext context) {
    var length = totalLength();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '글 작성',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(children: [
        Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("지역"),
                DropdownButton(
                  value: address,
                  items: <String>['북구', '남구']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 20,
                  onChanged: (String? newValue) {
                    setState(() {
                      address = newValue!;
                      if (address == '북구') {
                        location_north = true;
                      } else {
                        location_north = false;
                      }
                    });
                  },
                  elevation: 4,
                ),
                const SizedBox(height: 25.0),
                Text("제목"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffDBEE91),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDBEE91),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDBEE91),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: titleController,
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
                const SizedBox(height: 25.0),
                Text("내용"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffDBEE91),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDBEE91),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffDBEE91),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: contentController,
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                ),
                const SizedBox(height: 25.0),
                Text("사진"),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            //모서리를 둥글게
                            borderRadius: BorderRadius.circular(8)),
                        primary: Color(0xffDBEE91),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Color(0xff13740B)),
                          Text(
                            "선택",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.8)),
                          ),
                        ],
                      )),
                ),
              ],
            )),
        SizedBox(
          width: 120,
          child: ElevatedButton(
              onPressed: () {
                Firestore.collection("community").doc().set({
                  "comment": comment,
                  "comment_nickname": comment_nickname,
                  "comment_time": comment_time,
                  "like": like,
                  "title": title,
                  "content": content,
                  "address": address,
                  "created": created,
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffC0E2AF),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, color: Color(0xff13740B)),
                  const SizedBox(height: 8),
                  Text(
                    "게시하기",
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                  ),
                ],
              )),
        )
      ]),
    );
  }
}
