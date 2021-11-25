import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('내가 찜한 가게',
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
            const SizedBox(height: 10),
            Row(
              children: <Widget> [
                const SizedBox(width: 30),
                Text(
                  '찜한 가게',
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
                    //가게 상세로 가도록
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

