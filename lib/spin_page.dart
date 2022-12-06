// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/for_lunch.dart';
import 'main_model.dart';
import 'restaurant_view.dart';
import 'sign_in_page.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'num_restaurants_model.dart';

enum MenuItem { signIn, signOut }

// ignore: must_be_immutable
class SpinPage extends StatefulWidget {
  const SpinPage({super.key});

  @override
  State<SpinPage> createState() => _SpinPageState();
}

class _SpinPageState extends State<SpinPage> {
  //needed to use a BehaviorSubject<int> because we needed the .value method
  final wheelController = BehaviorSubject<int>();

  //These are the names of the restaurants that *will* be pulled by an api
  List<String> fortuneItems = [
    'McDonalds',
    'Dairy Queen',
    'Boba',
    'Mammas Noodles',
    'Pizza Hut',
    'Qdoba'
  ];

  int numPicked = 0; //number of times it has been picked
  String docID = 'thisis notworking';
  bool restaurantExist = false;

  @override
  Widget build(BuildContext context) {
    MainModel mainModel = Provider.of<MainModel>(context);
    var db = mainModel.getDatabase();
    CollectionReference numRestaurantDB = db.collection('NumResturantPicked');
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('What\'s For Lunch')),
          backgroundColor: Colors.red,
          actions: [
            if (mainModel.getCurrentUserName() == 'User Name')
              PopupMenuButton<MenuItem>(
                  //this figures out which navigation they are going to
                  onSelected: (value) {
                    if (value == MenuItem.signIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SignInPage()), //navigating to the My Memories page
                      );
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MenuItem.signIn,
                          child: Text('Sign In'),
                        ),
                      ]),
            if (mainModel.getCurrentUserName() != 'User Name')
              PopupMenuButton<MenuItem>(
                  //this figures out which navigation they are going to
                  onSelected: (value) {
                    if (value == MenuItem.signOut) {
                      mainModel.userSignedOut();
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: MenuItem.signOut,
                          child: Text('Sign Out'),
                        ),
                      ]),
          ]),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: Text('Swipe to Spin',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rajdhani')),
            ),
            if (mainModel.getCurrentUserName() != 'User Name')
              Text('Signed In As: ${mainModel.getCurrentUserName()}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Rajdhani')),
            FittedBox(
              child: FortuneBar(
                  styleStrategy: const UniformStyleStrategy(
                    color: Color.fromARGB(80, 253, 115, 91),
                    borderColor: Colors.red,
                    borderWidth: 3,
                  ),
                  visibleItemCount: 1,
                  indicators: [],
                  height: 400,
                  fullWidth: true,
                  // physics: CircularPanPhysics(
                  //   duration: const Duration(seconds: 0),
                  //   curve: Curves.decelerate,
                  // ),
                  //This sets what whill happen when the wheele is spun
                  onFling: () {
                    wheelController.add(Random().nextInt(mainModel.restaurantsNear.length));

                    mainModel.restaurantsNear.forEach((restaurant) async {
                      // ignore: unrelated_type_equality_checks
                      if (searchQuery(
                              restaurantName: restaurant.toString(),
                              userID: mainModel.userId,
                              db: numRestaurantDB) ==
                          false) {
                        //if returns false make it true so that it adds the restaurant to the database
                        addRestaurant(
                            numPicked: 1,
                            restaurantName: restaurant.toString(),
                            userId: mainModel.userId,
                            db: db);
                      }
                    });

                    //This delays the changing of screens long enough for the
                    //wheel to finish spinning
                    Timer(const Duration(seconds: 6), () {
                      int winningIndex = (wheelController.value == 0)
                          ? mainModel.restaurantsNear.length - 1
                          : wheelController.value! - 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RestaurantView(
                                startLat: mainModel.getUserCurrentLat(),
                                startLng: mainModel.getUserCurrentLng(),
                                endLat: mainModel.restaurantsNear[winningIndex]
                                    .getLat(),
                                endLng: mainModel.restaurantsNear[winningIndex]
                                    .getLng(),
                                restaurantName: mainModel.restaurantsNear[winningIndex].getName())),
                      );
                    });
                  },
                  animateFirst: false,
                  selected: wheelController.stream,
                  //this uses a forloop to make the FortuneItems along with
                  //the array items
                  items: [
                    for (int i = 0;
                        i < mainModel.restaurantsNear.length;
                        i++) ...<FortuneItem>{
                      FortuneItem(
                          style: const FortuneItemStyle(
                              borderWidth: 3,
                              borderColor: Colors.red,
                              color: Color.fromARGB(80, 251, 142, 161)),
                          child: Text(mainModel.restaurantsNear[i].getName(),
                              style: const TextStyle(
                                  fontFamily: 'Rajdhani', fontSize: 30))),
                    },
                  ]),
            ),
          ]),
    );
  }

//adds restaurant with the number of times it picks to the database
  Future<void> addRestaurant(
      {required int numPicked,
      required String restaurantName,
      required var userId,
      required var db}) {
    return db.collection('NumRestaurantPicked').add({
      'userId': userId,
      'numPicked': numPicked,
      'restaurantName': restaurantName
    });
  }

  //searches for the resturant and checks to see if it already exist
  //if it does, then update the numpicked and return true,
  //if it doesnt, then return false
  Future<bool> searchQuery(
      {required String restaurantName,
      required var userID,
      required db}) async {
    int addOne = 1; //addes one if it has been picked

//this is not working
    try {
      Query query2 =
          db.where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      Query query = query2.where('restaurantName', isEqualTo: 'Mammas Noodles');
      await query.get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          docID = doc.id;
          numPicked = doc['numPicked'];
          restaurantExist = true;
          // print('id: ${doc.id}');
          //  print('picked: ${doc['numPicked']}');
        });
      }).catchError((error) {
        // print('error querying: #error');
      });
      /* var query = db
          //.collection('NumRestaurantPicked')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      var query2 = query.where('restaurantName', isEqualTo: restaurantName);
      query2.get().then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          docID = doc.id;
          numPicked = doc['numPicked'];
          restaurantExist = true;
          print('id: ${doc.id}');
          print('picked: ${doc['numPicked']}');
        });
      }).catchError((error) {
        print('error querying: catching data is not working');
      });*/
    } catch (ex) {
      print(ex);
    }

//this is not working

    print(docID
        .toLowerCase()
        .toString()); //this is null because the query above is not excuting

    int totalPicked = numPicked + addOne;
//if the restaurant exist then update the numpicked for that specific restaurant
    if (restaurantExist) {
      try {
        var query = db
            //.collection('NumRestaurantPicked')
            .doc(docID);
        await query.update({'numPicked': totalPicked.toString()});
      } catch (ex) {}
    }
    print("hello>");
    return restaurantExist;
  }
}
