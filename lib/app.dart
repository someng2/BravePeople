import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hgu_21_2_mobileappdevelopment/store_detail.dart';

import 'community.dart';
import 'community_create.dart';
import 'community_detail.dart';
import 'community_main.dart';
import 'home.dart';
import 'login.dart';
import 'more.dart';
import 'service.dart';
import 'favorite.dart';
import 'myReview.dart';
import 'anouncement.dart';
import 'setting.dart';
import 'store.dart';
import 'store_detail.dart';
import 'add_review.dart';
import 'mypage.dart';
import 'introduce.dart';
import 'coupon.dart';

class BraveApp extends StatelessWidget {
  BraveApp({Key? key}) : super(key: key);

  final User? _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brave',
      home: HomePage(),
      initialRoute: _auth!.email == null ? '/login' : '/home',
      //initialRoute: '/login',
      // onGenerateRoute: _getRoute,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/more': (context) => MorePage(),
        '/mypage': (context) => const MyPage(),
        '/service': (context) => ServicePage(),
        '/favorite': (context) => FavoritePage(),
        '/myReview': (context) => MyReviewPage(),
        '/anouncement': (context) => AnouncementPage(),
        '/settings': (context) => SettingPage(),
        '/store': (context) => const Store(),
        '/storeDetail' : (context) => const StoreDetail(),
        '/community' : (context) => const Community(),
        '/communityMain' : (context) => const CommunityMain(),
        '/communityDetail' : (context) => const CommunityDetail(),
        '/communityCreate' : (context) => CommunityCreate(),
        '/introduce' : (context) => const IntroducePage(),
        '/coupon' : (context) => const CouponPage(),
        AddReview.routeName: (context) => const AddReview(),
      },
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}