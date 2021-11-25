import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnouncementPage extends StatefulWidget {
  @override
  _AnouncementPageState createState() => _AnouncementPageState();
}

class _AnouncementPageState extends State<AnouncementPage> {

  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('공지사항',
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
                DropdownButton(
                    value: _value,
                    items: [
                      DropdownMenuItem(
                        child: Text("2021 - 11 - 20 업데이트    ",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        value: 1,
                      ),
                      DropdownMenuItem(
                        child: Text("아직 이 부분은"),
                        value: 2,
                      ),
                      DropdownMenuItem(
                          child: Text("어떤 방식으로 구현하는지"),
                          value: 3
                      ),
                      DropdownMenuItem(
                          child: Text("정확히는 모르겠습니다."),
                          value: 4
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _value = value as int;
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}