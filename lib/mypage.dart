import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
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
                    onPressed: () {},
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
                    Text(data['nickname']),
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
                        children: [
                          const Text(
                            '휴대폰 번호',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 70),
                          Text(data['phone'])
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            )),
          );
        });
  }
}
