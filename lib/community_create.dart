import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CommunityCreate extends StatefulWidget {
  @override
  _CommunityCreateState createState() => _CommunityCreateState();
}

class _CommunityCreateState extends State<CommunityCreate> {
  FirebaseFirestore Firestore = FirebaseFirestore.instance;

  final String like = '0';
  String nickname = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String title = "";
  String content = "";
  String comment = "0";

  final List<String> location = ['북구', '남구'];
  String address = '북구';
  bool location_north = true;

  final picker = ImagePicker();
  File _image = File('');
  bool noImage = true;

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        nickname = doc['nickname'];
      });
    });

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
        elevation: 0,
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
                        left: 14.0, bottom: 100.0, top: 100.0),
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
                      onPressed: () {
                        getImage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
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
                const SizedBox(width: 25),
                (noImage)
                    ? Container(
                  width: 200,
                  height: 200,
                )
                    : Container(
                  child: Image.file(_image, fit: BoxFit.contain),
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 3,
                        color: const Color(0xffDBEE91)
                            .withOpacity(0.5)),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(8)),
                  ),
                ),
              ],
            )),
        SizedBox(
          width: 120,
          child: ElevatedButton(
              onPressed: () {
                upload(context,nickname);
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

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 650, maxHeight: 100);
    setState(() {
      _image = File(pickedFile!.path);
      noImage = false;
    });
  }

  Future upload(BuildContext context,String nickname) async {

    String created = DateFormat('yyyy-MM-dd-HH:mm').format(DateTime.now());

    try {

      // 스토리지에 업로드할 파일 경로
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('community_image')
          .child('$created.png');

      if (!noImage) {
        final uploadTask = firebaseStorageRef.putFile(
            _image, SettableMetadata(contentType: 'image/png'));
        await uploadTask.whenComplete(() => null);

        final downloadUrl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('community').doc('$title').set({
          "like": like,
          "title": title,
          "content": content,
          "address": address,
          "created": created,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'nickname': nickname,
          'imageUrl': downloadUrl,
          'noImage': false,
          'email': FirebaseAuth.instance.currentUser!.email,
          'comment': comment,
        });
      } else {
        await FirebaseFirestore.instance.collection('community').doc('$title').set({
          "like": like,
          "title": title,
          "content": content,
          "address": address,
          "created": created,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'nickname': nickname,
          'noImage': true,
          'email': FirebaseAuth.instance.currentUser!.email,
          'comment': comment,
        });
      }
    } catch (e) {
      print(e);
    }

    Navigator.pop(context);
  }
}
