import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
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
                centerTitle: true,
                title: const Text(
                  'My 쿠폰',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0,
              ),
              body: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Column(children: [
                    Center(
                        child: Container(
                            height: 50,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.yellow, width: 3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0,)),
                            ),
                            child: IconButton(
                                onPressed: () {
                                  _showBarcode(
                                      uid, data['coupon'], data['discount']);
                                },
                                icon: const Icon(Icons.attach_money)))),
                    const SizedBox(height: 5),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffC0E2AF).withOpacity(0.2),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        '쿠폰 적립 및 사용법',
                        style: TextStyle(color: Color(0xff8C8B8B)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('1. \'용기내는 사람들\' 어플에서 제휴점과 메뉴를 고른다.',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 15),
                          Text('2. 다회용품 용기 또는 텀블러를 챙긴다.',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 15),
                          Text('3. 제휴점을 방문한다.', style: TextStyle(fontSize: 15)),
                          SizedBox(height: 15),
                          Text(
                              '4. 제휴점에서 결제를 한 후, \'My 쿠폰\' 페이지 상단에 있는 \$ 아이콘을 클릭한다.',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 15),
                          Text('5. 매장 직원에게 바코드를 보여주고, 쿠폰 스탬프를 받는다.',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 15),
                          Text('6. 스탬프 9개를 모아 10% 할인권을 받는다.',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffC0E2AF).withOpacity(0.2),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        '내가 보유한 할인권',
                        style: TextStyle(color: Color(0xff8C8B8B)),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('10% 할인권 : ',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Text(data['discount'].toString(),
                                style: const TextStyle(
                                    fontSize: 27,
                                    color: Color(0xfff7b3c2),
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 5),
                            const Text('개', style: TextStyle(fontSize: 20))
                          ]),
                    ),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: const Color(0xffC0E2AF).withOpacity(0.2),
                      ),
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        '적립된 쿠폰',
                        style: TextStyle(color: Color(0xff8C8B8B)),
                      ),
                    ),
                  ]);
                }).toList(),
              ));
        });
  }

  void _showBarcode(String uid, int prev_coupon, int prev_discount) {
    prev_coupon++;
    if (prev_coupon == 9) {
      prev_coupon = 0;
      prev_discount++;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('제휴점 직원에게\n아래 바코드를 보여주세요'),
            content: TextButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc('$uid')
                      .update({
                    'coupon': prev_coupon,
                    'discount': prev_discount
                  }).catchError(
                          (error) => print("Failed to update user: $error"));
                  Navigator.pop(context);
                },
                child: Image.asset('assets/barcode.jpeg')),
            actions: <Widget>[
              TextButton(
                child: const Text("닫기",
                    style: TextStyle(color: Colors.black54, fontSize: 15)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });

  }
}
