import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddReview extends StatefulWidget {
  const AddReview({Key? key}) : super(key: key);

  static const routeName = '/addReview';

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int star_count = 1;

  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;

  File _image = File('');
  bool noImage = true;

  final picker = ImagePicker();

  String nickname = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store_id;
    final _textcontroller = TextEditingController();

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        nickname = doc['nickname'];
        print('nickname: $nickname');
      });
    });

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
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
              ),
              body: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 30,
                        ),
                        Text('별점', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: const Icon(
                              Icons.star,
                              size: 40,
                            ),
                            color: Colors.yellow,
                            onPressed: () {
                              setState(() {
                                star_count = 1;
                              });
                            }),
                        IconButton(
                            icon: (star_count >= 2
                                ? const Icon(
                                    Icons.star,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.star_outline_outlined,
                                    size: 40,
                                  )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star2, 2);
                            }),
                        IconButton(
                            icon: (star_count >= 3
                                ? const Icon(
                                    Icons.star,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.star_outline_outlined,
                                    size: 40,
                                  )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star3, 3);
                            }),
                        IconButton(
                            icon: (star_count >= 4
                                ? const Icon(
                                    Icons.star,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.star_outline_outlined,
                                    size: 40,
                                  )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star4, 4);
                            }),
                        IconButton(
                            icon: (star_count == 5
                                ? const Icon(
                                    Icons.star,
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.star_outline_outlined,
                                    size: 40,
                                  )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star5, 5);
                            }),
                      ],
                    ),
                    // Text('star count: $star_count'),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextField(
                        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|가-힣|ㆍ|ᆢ'))],
                        controller: _textcontroller,
                        maxLines: 6,
                        decoration: InputDecoration(
                          // hintText: '리뷰 10자 이상 작성해 주세요 :)',
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xffDBEE91).withOpacity(0.3),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color:
                                      const Color(0xffDBEE91).withOpacity(0.3),
                                  width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(
                                  color:
                                      const Color(0xffDBEE91).withOpacity(0.3),
                                  width: 2)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: const [
                        SizedBox(
                          width: 30,
                        ),
                        Text('사진', style: TextStyle(fontSize: 17)),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffDBEE91).withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              getImage();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Row(children: const [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                Text(' 선택',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                          ),
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
                    ),

                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffC0E2AF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () {
                              upload(context, args.store_id,
                                  _textcontroller.text, star_count, nickname);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: const [
                                Icon(Icons.edit, color: Color(0xff13740B)),
                                Text(' 게시하기',
                                    style: TextStyle(color: Colors.black))
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList()));
        });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 650, maxHeight: 100);
    setState(() {
      _image = File(pickedFile!.path);
      noImage = false;
    });
  }

  Future upload(BuildContext context, int store_id, String content,
      int star_count, String nickname) async {
    String time = DateTime.now().millisecondsSinceEpoch.toString();
    print(FirebaseAuth.instance.currentUser!.uid);

    try {

      // 스토리지에 업로드할 파일 경로
      final firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child('review_image') //'review_image'라는 folder를 만들고
          .child('$time.png');

      if (!noImage) {
        // 파일 업로드
        final uploadTask = firebaseStorageRef.putFile(
            _image, SettableMetadata(contentType: 'image/png'));
        // 완료까지 기다림
        await uploadTask.whenComplete(() => null);
        // print('nickname_: $nickname');

        // 업로드 완료 후 url
        final downloadUrl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance.collection('review').doc('$time').set({
          'store_id': store_id,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'nickname': nickname,
          'created': time,
          'content': content,
          'star': star_count,
          'imageUrl': downloadUrl,
          'noImage': false,
        });
      } else {
        // print('nickname_: $nickname');
        await FirebaseFirestore.instance.collection('review').doc('$time').set({
          'store_id': store_id,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'nickname': nickname,
          'created': time,
          'content': content,
          'star': star_count,
          'noImage': true,
        });
      }
    } catch (e) {
      print(e);
    }

    Navigator.pop(context);
  }

  void _toggleStar(bool star_, int count) {
    setState(() {
      if (star_) {
        if (count == 2) {
          // star2 = false;
          star3 = false;
          star4 = false;
          star5 = false;
          star_count = 2;
        } else if (count == 3) {
          star3 = false;
          star4 = false;
          star5 = false;
          star_count = 3;
        } else if (count == 4) {
          // star4 = false;
          star5 = false;
          star_count = 4;
        }
      } else {
        if (count == 2) {
          star2 = true;
          star_count = 2;
        }

        if (count == 3) {
          star2 = true;
          star3 = true;
          star_count = 3;
        }

        if (count == 4) {
          star2 = true;
          star3 = true;
          star4 = true;
          star_count = 4;
        }

        if (count == 5) {
          star2 = true;
          star3 = true;
          star4 = true;
          star5 = true;
          star_count = 5;
        }
      }
    });
  }
}
