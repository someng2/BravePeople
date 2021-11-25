import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  bool isSwitched1 = false;
  bool isSwitched2 = false;
  bool isSwitched3 = false;
  bool isSwitched4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('환경 설정',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
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
      body: SafeArea(
        child: ListView(
          children: <Widget> [
            Divider(color: Color(0xffC0E2AF), thickness: 16.0),
            Row(
              children: <Widget> [
                Container(
                  width: 392.7,
                  height: 40,
                  color: Color(0xffC0E2AF),
                  child: Column(
                    children: <Widget> [
                      const SizedBox(height: 5),
                      Text('알림'),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: <Widget> [
                const SizedBox(width: 35),
                Text(
                  '우리 동네 신규 제휴점 소식',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 100),
                Switch(
                  value: isSwitched1,
                  onChanged: (value) {
                    setState(() {
                      isSwitched1 = value;
                      print(isSwitched1);
                    });
                  },
                  activeTrackColor: Color(0xffDBEE91),
                  activeColor: Colors.white,
                ),
              ],
            ),
            Divider(color: Colors.grey, thickness: 2.0),
            const SizedBox(height: 10),
            Row(
              children: <Widget> [
                Column(
                  children: <Widget> [
                    Text(
                      '커뮤니티 댓글',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: <Widget> [
                        //const SizedBox(width: 35),
                        Text(
                          '              내 커뮤니티 게시글 댓글 알림',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 145),
                Switch(
                  value: isSwitched2,
                  onChanged: (value) {
                    setState(() {
                      isSwitched2 = value;
                      print(isSwitched2);
                    });
                  },
                  activeTrackColor: Color(0xffDBEE91),
                  activeColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey, thickness: 2.0),
            const SizedBox(height: 10),
            Row(
              children: <Widget> [
                Column(
                  children: <Widget> [
                    Text(
                      '리뷰 작성            ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: <Widget> [
                        //const SizedBox(width: 35),
                        Text(
                          '              쿠폰 적립한 제휴점 리뷰 작성 알림',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 125),
                Switch(
                  value: isSwitched3,
                  onChanged: (value) {
                    setState(() {
                      isSwitched3 = value;
                      print(isSwitched3);
                    });
                  },
                  activeTrackColor: Color(0xffDBEE91),
                  activeColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey, thickness: 2.0),
            const SizedBox(height: 10),
            Row(
              children: <Widget> [
                Column(
                  children: <Widget> [
                    Text(
                      '리뷰 댓글  ',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: <Widget> [
                        //const SizedBox(width: 35),
                        Text(
                          '                내 리뷰에 달린 댓글 알림',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 160),
                Switch(
                  value: isSwitched4,
                  onChanged: (value) {
                    setState(() {
                      isSwitched4 = value;
                      print(isSwitched4);
                    });
                  },
                  activeTrackColor: Color(0xffDBEE91),
                  activeColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey, thickness: 2.0),
          ],
        ),
      ),
    );
  }
}

