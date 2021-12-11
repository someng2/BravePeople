import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where(
              'email',
              isEqualTo: FirebaseAuth.instance.currentUser!.email,
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
              centerTitle: true,
              title: const Text(
                '더보기',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              elevation: 0,
            ),
            body: Center(
                child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: <Widget>[
                    Divider(
                        color: Color(0xffC0E2AF).withOpacity(0.2),
                        thickness: 10.0),
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 30),
                            ClipOval(
                              child: Image.network(
                                'https://st4.depositphotos.com/1156795/20814/v/950/depositphotos_208142514-stock-illustration-profile-placeholder-image-gray-silhouette.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 20),

                            /// text 자
                            Text(data['nickname']),
                            const SizedBox(width: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    //mypage 정보 수정으로 가야함
                                    Navigator.pushNamed(context, '/mypage');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 1.0),
                        Center(
                          child: SizedBox(
                            height: 120,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          // padding: EdgeInsets.fromLTRB(30, 15, 50, 20),
                                          // icon: Icon(Icons.thumb_up, size: 60, color: Colors.yellowAccent),
                                          //   child: Image.asset('assets/like.png', height: 90, width: 10),
                                          child: Image.asset('assets/gift.png',
                                              fit: BoxFit.contain, height: 73),
                                          onPressed: () {
                                            //나의 리뷰로 가야
                                            Navigator.pushNamed(
                                                context, '/coupon');
                                          },
                                        ),
                                        // const SizedBox(height: 5),
                                        const Text(
                                          '쿠폰',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          // padding: const EdgeInsets.fromLTRB(0, 15, 40, 20),
                                          child: Image.asset(
                                              'assets/favorite.png',
                                              fit: BoxFit.contain,
                                              height: 73),
                                          onPressed: () {
                                            //찜 목록으로 가야함
                                            Navigator.pushNamed(
                                                context, '/favorite');
                                          },
                                        ),
                                        const Text(
                                          '찜',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        TextButton(
                                          child: Image.asset(
                                              'assets/review.png',
                                              fit: BoxFit.contain,
                                              height: 73),
                                          onPressed: () {
                                            //나의 리뷰로 가야
                                            Navigator.pushNamed(
                                                context, '/myReview');
                                          },
                                        ),
                                        const Text(
                                          '나의 리뷰',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ]),
                          ),
                        ),
                        // Divider(color: Colors.grey, thickness: 2.0),
                        Divider(
                            color: Color(0xffC0E2AF).withOpacity(0.2),
                            thickness: 10.0),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 30),
                            Text(
                              '어플 소개',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 190),
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                //어플 소개로 가야함
                                Navigator.pushNamed(context, '/introduce');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 1.0),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 30),
                            Text(
                              '공지사항',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 195),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                //공지사항으로 가야함
                                Navigator.pushNamed(context, '/anouncement');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 1.0),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 30),
                            Text(
                              '고객센터',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 195),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                //고객센터로 가야함
                                Navigator.pushNamed(context, '/service');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 1.0),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            const SizedBox(width: 30),
                            Text(
                              '환경 설정',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(width: 190),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                //환경설정으로 가야함
                                Navigator.pushNamed(context, '/settings');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.grey, thickness: 1.0),
                      ],
                    ),
                  ],
                );
              }).toList(),
            )),
          );
        });
  }
}
