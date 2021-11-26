import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class AddReview extends StatefulWidget {
  const AddReview({Key? key}) : super(key: key);

  static const routeName = '/addReview';

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  int star_count = 1;

  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Store_id;

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('store')
            .where('store_id', isEqualTo: args.store_id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
              ),
              body: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: const [
                        SizedBox(
                          width: 30,
                        ),
                        Text('별점', style: TextStyle(fontSize: 17)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            icon:
                            const Icon(
                              Icons.star,
                              size: 40,
                            ) ,
                            color: Colors.yellow,
                            onPressed: () {
                              setState(() {
                                star_count = 1;
                              });
                            }),
                        IconButton(
                            icon: (star_count >= 2 ? const Icon(
                              Icons.star,
                              size: 40,
                            ) :
                            const Icon(
                              Icons.star_outline_outlined,
                              size: 40,
                            )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star2, 2);
                            }),
                        IconButton(
                            icon: (star_count >= 3 ? const Icon(
                              Icons.star,
                              size: 40,
                            ) :
                            const Icon(
                              Icons.star_outline_outlined,
                              size: 40,
                            )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star3, 3);
                            }),
                        IconButton(
                            icon: (star_count >= 4 ? const Icon(
                              Icons.star,
                              size: 40,
                            ) :
                            const Icon(
                              Icons.star_outline_outlined,
                              size: 40,
                            )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star4, 4);
                            }),
                        IconButton(
                            icon: (star_count == 5 ? const Icon(
                              Icons.star,
                              size: 40,
                            ) :
                            const Icon(
                              Icons.star_outline_outlined,
                              size: 40,
                            )),
                            color: Colors.yellow,
                            onPressed: () {
                              _toggleStar(star5, 5);
                            }),

                      ],
                    ),
                    Text('star count: $star_count'),
                  ],
                );
              }).toList()));
        });
  }

  void _toggleStar(bool star_, int count) {
    setState(() {
      if (star_) {

        if (count == 2) {
          // star2 = false;
          star3 = false;
          star4 = false;
          star5 = false;
          star_count = 2;
        }
        else if (count == 3) {
          star3 = false;
          star4 = false;
          star5 = false;
          star_count = 3;
        }
        else if (count == 4) {
          // star4 = false;
          star5 = false;
          star_count = 4;
        }
        // else if (count == 5)
        //   star5 = false;

         // if (count < 5)
         //   star_count --;

      } else {

        if (count == 2) {
          star2 = true;
          star_count = 2;
        }

        if (count == 3) {
          star2 = true;
          star3 = true;
          star_count = 3;
        }

        if (count == 4) {
          star2 = true;
          star3 = true;
          star4 = true;
          star_count = 4;
        }

        if (count == 5) {
          star2 = true;
          star3 = true;
          star4 = true;
          star5 = true;
          star_count = 5;
        }




      }

    });
  }
}
