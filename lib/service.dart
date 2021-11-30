import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('고객센터',
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
            Navigator.pushNamed(context, '/more');
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget> [
            Divider(color: const Color(0xffC0E2AF).withOpacity(0.2), thickness: 10.0),
            Column(
              children: <Widget> [
                const SizedBox(height: 30),
                Row(
                  children: const <Widget> [
                    SizedBox(width: 20),
                    Text('문의 연락처',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  children: const <Widget> [
                    SizedBox(width: 20),
                    Text('email: 21xxxxxx@handong.edu',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  children: const <Widget> [
                    SizedBox(width: 20),
                    Text('phone: 010-xxxx-xxxx',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Divider(color: Colors.grey, thickness: 1.0),
          ],
        ),
      ),
    );
  }
}

