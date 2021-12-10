import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
  String uid = userCredential.user!.uid;
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  if (snapshot.docs.isEmpty) {
    // DocumentReference user =
    await FirebaseFirestore.instance
        .collection('user')
        .doc('$uid')
        .set(<String, dynamic>{
      'name': userCredential.user!.displayName,
      'email': userCredential.user!.email,
      'uid': userCredential.user!.uid,
      'nickname': '에코몽',
      'phone': '',
      'discount': 0,
      'coupon': 0,
    });
  }

  return await userCredential;
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 60.0),
            Column(
              children: <Widget>[
                const Text(
                  '용기내는 사람들',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      decorationThickness: 2.0,
                      color: Color(0xff13740B)),
                ),
                const SizedBox(height: 30.0),
                Container(
                  width: 500,
                  child: Divider(color: Color(0xff13740B), thickness: 4.0),
                ),
                const SizedBox(height: 16.0),
                Image.asset('assets/heart.jpeg'),
              ],
            ),
            const SizedBox(height: 100.0),
            SizedBox(
              height: 60,
              width: 40,
              child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          // height: 60,
                          child: Image.network(
                              'https://cdn.icon-icons.com/icons2/2699/PNG/512/google_logo_icon_169090.png',
                              width: 30,
                              fit: BoxFit.contain)),
                      const SizedBox(width: 15),
                      const Text('Google Sign in',
                          style: TextStyle(fontSize: 17, color: Colors.black)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xfff7b3c2).withOpacity(0.9),
                  ),
                  onPressed: () async {
                    signInWithGoogle();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
