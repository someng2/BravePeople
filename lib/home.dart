import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
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
                    Text('용기내는 사람들',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          decorationThickness: 2.0,
                          color: Color(0xff13740B)
                      ),
                    ),
                    const SizedBox(width: 40.0),
                    IconButton(
                      icon: Icon(Icons.menu, color: Color(0xff13740B)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/more');
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
                        padding: EdgeInsets.fromLTRB(0, 10, 75, 0),
                          icon: Icon(Icons.restaurant, size: 100),
                          onPressed: () {
                            //제휴점으로 가야함
                            Navigator.pushNamed(context, '/store');
                          },
                      ),
                      const SizedBox(height: 100.0),
                      const SizedBox(width: 120.0),
                      Text('제휴점',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                      ),
                    ],
                  ),
                ),
                //const SizedBox(width: 60.0),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBEE91),
                    border: Border.all(width: 10, color: Color(0xffdbee91)),
                    borderRadius: const BorderRadius.all(const Radius.circular(8)),
                  ),
                  child: Column(
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.fromLTRB(0, 10, 75, 0),
                          icon: Icon(Icons.people, size: 100, color: Colors.pinkAccent),
                          onPressed: () {
                            //커뮤니티로 가야함
                            //Navigator.pushNamed(context, '/login');
                          },
                      ),
                      const SizedBox(height: 100.0),
                      const SizedBox(width: 120.0),
                      Text('커뮤니티',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40.0),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffD0E5BD),
                border: Border.all(width: 10, color: Color(0xffD0E5BD)),
                borderRadius: const BorderRadius.all(const Radius.circular(8)),
              ),
              child: Row(
                children: <Widget> [
                  Column(
                    children: <Widget> [
                      IconButton(
                        padding: EdgeInsets.fromLTRB(20, 10, 60, 20),
                        icon: Icon(Icons.wallet_giftcard, size: 60, color: Colors.lightBlueAccent),
                        onPressed: () {
                          //쿠폰으로 가야함
                          //Navigator.pushNamed(context, '/login');
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text('쿠폰',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30.0),
                  Column(
                    children: <Widget> [
                      IconButton(
                        padding: EdgeInsets.fromLTRB(0, 10, 40, 20),
                        icon: Icon(Icons.favorite, size: 60, color: Colors.red),
                        onPressed: () {
                          //찜 목록으로 가야함
                          Navigator.pushNamed(context, '/favorite');
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text('찜',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20.0),
                  Column(
                    children: <Widget> [
                      IconButton(
                        padding: EdgeInsets.fromLTRB(30, 10, 50, 20),
                        icon: Icon(Icons.thumb_up, size: 60, color: Colors.yellowAccent),
                        onPressed: () {
                          //나의 리뷰로 가야함
                          Navigator.pushNamed(context, '/myReview');
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text('나의 리뷰',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),
            Container(
              decoration: BoxDecoration(
                color: Color(0xffC0E2AF),
                border: Border.all(width: 10, color: Color(0xffC0E2AF)),
                borderRadius: const BorderRadius.all(const Radius.circular(8)),
              ),
              child: Text(
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
