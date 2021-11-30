import 'package:flutter/material.dart';

class IntroducePage extends StatelessWidget {
  const IntroducePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '어플 소개',
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
        body: Column(
          children: [
            Divider(
                color: const Color(0xffC0E2AF).withOpacity(0.2),
                thickness: 10.0),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Text(
                  '\'용기 내는 사람들’은 다회용품 이용 장려 및 환경 보호 커뮤니티 어플입니다.\n\n포항 지역에 위치한 제휴점에서 다회용품 이용 시, 제휴점 할인을 받을 수 있는 서비스를 제공하고 있습니다.\n우리 집 주변 제휴점의 위치도 확인할 수 있답니다!\n\n환경 보호를 위한 나의 이야기를 사람들과 공유하며, 우리 함께 환경을 지켜요 :)',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            Image.asset('assets/heart.jpeg', height: 250,),
          ],
        ));
  }
}
