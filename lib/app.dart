import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'more.dart';
import 'service.dart';
import 'favorite.dart';
import 'myReview.dart';
import 'anouncement.dart';
import 'setting.dart';

class BraveApp extends StatelessWidget {
  BraveApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brave',
      home: HomePage(),
      initialRoute: '/login',
      // onGenerateRoute: _getRoute,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/more': (context) => MorePage(),
        '/service': (context) => ServicePage(),
        '/favorite': (context) => FavoritePage(),
        '/myReview': (context) => MyReviewPage(),
        '/anouncement': (context) => AnouncementPage(),
        '/settings': (context) => SettingPage(),
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