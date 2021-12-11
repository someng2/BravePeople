import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'store.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPagePageState createState() => _MapPagePageState();
}

class _MapPagePageState extends State<MapPage> {

  List<Marker> _markers = [];

  Completer<GoogleMapController> _controller = Completer();

  String star_avg = '';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final args = ModalRoute.of(context)!.settings.arguments as Store_id;

    if (args.review_count > 0) {
      star_avg = (args.star_sum / args.review_count)
          .toStringAsFixed(1);
    }

    _markers.add(Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () {
          var  bottomSheetController=scaffoldKey.currentState!.showBottomSheet((context) => Container(
            child: getBottomSheet(args.name, args.review_count, args.address_gu, args.address, args.phone, args.image, star_avg),
            height: 250,
            color: Colors.transparent,
          ));
        },
        position: LatLng(args.latitude, args.longitude)));

    CameraPosition storePosition = CameraPosition(
      target: LatLng(args.latitude, args.longitude),
      zoom: 17.9946,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(args.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
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
      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set.from(_markers),
        initialCameraPosition: storePosition,
        myLocationEnabled :true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Widget getBottomSheet(String name, int review_count, String address_gu, String address, String phone, String image, String star_avg)
  {
    return Stack(
      children: <Widget>[
        Container(

          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Color(0xffC0E2AF),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        '$image',
                        width: 80,
                        height: 60,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('$name',style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14
                          ),),
                          const SizedBox(height: 5,),
                          Row(children: <Widget>[
                            if(review_count != 0) Icon(Icons.star,color: Colors.yellow,),
                            SizedBox(width: 10,),
                            Text('$star_avg',style: TextStyle(
                                color: Colors.white,
                                fontSize: 14
                            ))
                          ],),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.map,color: Color(0xffC0E2AF),),SizedBox(width: 20,),Text("$address_gu" + " " +"$address")],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.call,color: Color(0xffC0E2AF),),SizedBox(width: 20,),Text("$phone")],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
                child: const Icon(Icons.arrow_drop_down_sharp, size: 30,),
                onPressed: (){
                  Navigator.pop(context);
                }),
          ),
        )
      ],

    );
  }

}
