import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Username {
  final String username;

  Username(this.username);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    String username = '';

    FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        username = doc['nickname'];
      });
    });
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: const Color(0xffF3FAEF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 60.0),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 80.0),
                    const Text('용기내는 사람들',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 2.0,
                          color: Color(0xff13740B)
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Color(0xff13740B)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/more', arguments: Username(username));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Container(
                  width: 500,
                  child: Divider(color: Color(0xff13740B), thickness: 2.0),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffC0E2AF),
                    border: Border.all(width: 10, color: Color(0xffC0E2AF)),
                    borderRadius: const BorderRadius.all(const Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.fromLTRB(20, 10, 75, 0),
                          icon: Icon(Icons.restaurant, size: 80),
                          onPressed: () {
                            //제휴점으로 가야함
                            Navigator.pushNamed(context, '/store');
                          },
                      ),
                      const SizedBox(height: 90.0),
                      const SizedBox(width: 120.0),
                      const Text('제휴점',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                //const SizedBox(width: 60.0),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffDBEE91).withOpacity(0.8),
                    border: Border.all(width: 10, color: const Color(0xffdbee91).withOpacity(0.8),),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.fromLTRB(20, 10, 75, 0),
                          icon: Icon(Icons.people, size: 80, color: Colors.pinkAccent),
                          onPressed: () {
                            //커뮤니티로 가야함
                            Navigator.pushNamed(context, '/communityMain');
                          },
                      ),
                      const SizedBox(height: 90.0),
                      const SizedBox(width: 120.0),
                      const Text('커뮤니티',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 5, color: Color(0xffC0E2AF)),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),

              child: Center(
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
                                    fit: BoxFit.contain, height: 75),
                                onPressed: () {
                                  //나의 리뷰로 가야
                                  Navigator.pushNamed(context, '/coupon');
                                },
                              ),
                              const SizedBox(height: 7),
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
                                child: Image.asset('assets/favorite.png',
                                    fit: BoxFit.contain, height: 65),
                                onPressed: () {
                                  //찜 목록으로 가야함
                                  Navigator.pushNamed(context, '/favorite');
                                },
                              ),
                              const SizedBox(height: 12),
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
                                // padding: EdgeInsets.fromLTRB(30, 15, 50, 20),
                                // icon: Icon(Icons.thumb_up, size: 60, color: Colors.yellowAccent),
                                //   child: Image.asset('assets/like.png', height: 90, width: 10),
                                child: Image.asset('assets/review.png',
                                    fit: BoxFit.contain, height: 80),
                                onPressed: () {
                                  //나의 리뷰로 가야
                                  Navigator.pushNamed(context, '/myReview');
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
              // child: Row(
              //   children: <Widget> [
              //     Column(
              //       children: <Widget> [
              //         IconButton(
              //           padding: EdgeInsets.fromLTRB(20, 10, 60, 20),
              //           icon: Icon(Icons.wallet_giftcard, size: 60, color: Colors.lightBlueAccent),
              //           onPressed: () {
              //             //쿠폰으로 가야함
              //             Navigator.pushNamed(context, '/coupon');
              //           },
              //         ),
              //         const SizedBox(height: 20.0),
              //         Text('쿠폰',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             fontSize: 15,
              //           ),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(width: 30.0),
              //     Column(
              //       children: <Widget> [
              //         IconButton(
              //           padding: EdgeInsets.fromLTRB(0, 10, 40, 20),
              //           icon: Icon(Icons.favorite, size: 60, color: Colors.red),
              //           onPressed: () {
              //             //찜 목록으로 가야함
              //             Navigator.pushNamed(context, '/favorite');
              //           },
              //         ),
              //         const SizedBox(height: 20.0),
              //         Text('찜',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             fontSize: 15,
              //           ),
              //         ),
              //       ],
              //     ),
              //     const SizedBox(width: 20.0),
              //     Column(
              //       children: <Widget> [
              //         IconButton(
              //           padding: EdgeInsets.fromLTRB(30, 10, 50, 20),
              //           icon: Icon(Icons.thumb_up, size: 60, color: Colors.yellowAccent),
              //           onPressed: () {
              //             //나의 리뷰로 가야함
              //             Navigator.pushNamed(context, '/myReview');
              //           },
              //         ),
              //         const SizedBox(height: 20.0),
              //         Text('나의 리뷰',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             fontSize: 15,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
            ),
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffC0E2AF).withOpacity(0.2),
                border: Border.all(width: 10, color: Color(0xffC0E2AF).withOpacity(0.2)),
                borderRadius: const BorderRadius.all(const Radius.circular(8)),
              ),
              child: const Text(
                'MobileAppDevelopment',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
//List<bool> isSelected = [true, false];
//List<Hotel> hotels = HotelsRepository.loadHotels();

}
