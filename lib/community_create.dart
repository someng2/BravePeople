import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CommunityCreate extends StatefulWidget {
  @override
  _CommunityCreateState createState() => _CommunityCreateState();
}

class _CommunityCreateState extends State<CommunityCreate> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  TextEditingController addressController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  String time = DateTime.now().millisecondsSinceEpoch.toString();

  String address = "";
  String title = "";
  String content = "";
  String id = FirebaseFirestore.instance.collection('products').snapshots().length.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
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
      body: Column(children: [
        Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("지역"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xffDBEE91),
                    hintText: ('북구or남구'),
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
                  controller: addressController,
                  onChanged: (value) {
                    setState(() {
                      address = value;
                    });
                  },
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
                SizedBox(
                  height: 200,
                  width: 400,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xffDBEE91),
                      borderRadius: const BorderRadius.all(
                          const Radius.circular(8)),
                    ),
                    child: TextField(
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
                  ),
                ),
                const SizedBox(height: 25.0),
                Text("사진"),
                SizedBox(
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () {
                        Firestore.collection("community").doc().set({});
                      },
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
                  "title": title,
                  "content": content,
                  "address": address,
                  "created": time,
                  "community_id": id,
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xffC0E2AF),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.border_color, color: Color(0xff13740B)),
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
