import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyReviewPage extends StatefulWidget {
  @override
  _MyReviewPageState createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('나의 리뷰',
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
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget> [
            SizedBox(height: 10),
            Divider(color: Color(0xffC0E2AF).withOpacity(0.2), thickness: 10.0),
            Row(
              children: <Widget> [
                const SizedBox(width: 30),
                Text(
                  '가게 이름',
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
                    //해당리뷰로 가도록
                    //Navigator.pushNamed(context, '/mypage');
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

