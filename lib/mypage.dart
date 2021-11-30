import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final nickcontroller = TextEditingController();
    final phonecontroller = TextEditingController();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where(
              'uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
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
              title: const Text(
                '내 정보 수정',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              elevation: 0,
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('user')
                          .doc('$uid')
                          .update({
                        'nickname': nickcontroller.text,
                        'phone': phonecontroller.text,
                      }).catchError((error) =>
                              print("Failed to update user: $error"));

                      Navigator.pop(context);
                    },
                    child:
                        const Text('저장', style: TextStyle(color: Colors.black)))
              ],
            ),
            body: Center(
                child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    ClipOval(
                      child: Image.network(
                        'https://st4.depositphotos.com/1156795/20814/v/950/depositphotos_208142514-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: TextField(
                        controller: nickcontroller..text = data['nickname'],
                        maxLines: 1,
                        decoration: const InputDecoration(
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Divider(
                        color: const Color(0xffC0E2AF).withOpacity(0.2),
                        thickness: 10.0),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          const Text(
                            '이메일',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 70),
                          Text(data['email'])
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: const [
                          Text(
                            '휴대폰 번호',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 70),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      height: 35,
                      child: TextField(
                        controller: phonecontroller..text = data['phone'],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xffC0E2AF).withOpacity(0.4),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1)),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () async {
                              try {
                                await signOut();
                                print("Logout Success");
                              } catch (e) {
                                print(e.toString());
                              }
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => LoginPage()),
                                      (route) => false);
                            },
                            child: const Text('로그아웃',
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline))),
                        const SizedBox(width: 15),
                      ],
                    )
                  ],
                );
              }).toList(),
            )),
          );
        });
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
  }
}
