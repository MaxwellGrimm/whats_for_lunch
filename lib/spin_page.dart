// ignore_for_file: unused_local_variable, empty_catches

import 'dart:async';

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_for_lunch/num_restaurants_model.dart';
import 'main_model.dart';
import 'restaurant_view.dart';
import 'sign_in_page.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';

// ignore: slash_for_doc_comments
/**
Name: Max Grimm, Xee Lo
Date: Decemeber 12, 2023
Description: This page has the fortune wheele and a sign in option
you swipe the card either way to spin and get a random restaurant from
those loaded given your location.
This is where NumRestaurant gets populated from the list and gets stored in the main model. 
That then displays on the profile page.
Bugs: The Fortune wheele can't be empty so this page is not allowed to be loaded
until the main model's list of restaurants are filled.
Reflection: I would have liked to add photos but we didn't get the api connected
until recently. 
This is where NumRestaurant gets populated from the list and gets stored in the main model.
 
*/

//for switching the option depending if the user is signed in or not
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
  int numPicked = 1;
  //for later when the fling is called
  int? winningRestaurantIndex;

  @override
  Widget build(BuildContext context) {
    //main model to populate the fortune wheel
    MainModel mainModel = Provider.of<MainModel>(context);
    //this is the db from the model that was supposed to be used for adding
    //recently spun values 
    var db = mainModel.getDatabase();
    CollectionReference numRestaurantDB = db.collection('NumRestaurantPicked');
    return Scaffold(
      appBar: AppBar(
        //adds the sign in and sign out functionality 
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
                      //this is a custom font 
                      fontFamily: 'Rajdhani')),
            ),
            //displays the username if the user is signed in
            if (mainModel.getCurrentUserName() != 'User Name')
              Text('Signed In As: ${mainModel.getCurrentUserName()}',
                  style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Rajdhani')),
            FittedBox(
              //this is the fortuneBar where all of the restaurants will be held
              child: FortuneBar(
                  styleStrategy: const UniformStyleStrategy(
                    color: Color.fromARGB(80, 253, 115, 91),
                    borderColor: Colors.red,
                    borderWidth: 3,
                  ),
                  visibleItemCount: 1,
                  //since only one restaurant will be displayed on the screen
                  //we don't need an indicator
                  // ignore: prefer_const_literals_to_create_immutables
                  indicators: [],
                  height: 400,
                  fullWidth: true,
                  //This sets what whill happen when the wheele is spun
                  onFling: () {
                    wheelController.add(
                        Random().nextInt(mainModel.restaurantsNear.length));

                    //This delays the changing of screens long enough for the
                    //wheel to finish spinning
                    Timer(const Duration(seconds: 6), () {
                      //there was an error where the fortune wheel was not
                      //pulling up the correct restaurant 
                      int winningIndex = (wheelController.value == 0)
                          ? mainModel.restaurantsNear.length - 1
                          : wheelController.value! - 1;
                      winningRestaurantIndex = winningIndex;
                      if (updateRestaurantPicked(
                              //if this is false then it goes and adds the restaurant for the first time
                              restaurantName: mainModel
                                  .restaurantsNear[winningRestaurantIndex!]
                                  .getName(),
                              model: mainModel) ==
                          false) {
                        //adds the restaurant to the list if it has never been picked
                        addRestaurantToList(
                            numPicked: numPicked,
                            restaurantName: mainModel
                                .restaurantsNear[winningRestaurantIndex!]
                                .getName(),
                            model: mainModel);
                      }
                      //this navigates the page to the dynamically created
                      //restaurant view page for the restaurant that the 
                      //fortune wheel lands on
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
                                restaurantName: mainModel
                                    .restaurantsNear[winningIndex]
                                    .getName())),
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
                                  fontFamily: 'Rajdhani', fontSize: 30,
                                  fontWeight: FontWeight.bold,))),
                    },
                  ]),
            ),
          ]),
    );
  }

//adds the restaurant to the list in the main model
//required int numPicked - number of times it was picked
// required String restaurantName - restaurantName
  //required MainModel model - the main model storing all the data
  void addRestaurantToList(
      {required int numPicked,
      required String restaurantName,
      required MainModel model}) {
    NumRestaurant
        numRestaruantModel = //create an object instance of NumRestaurant so that you can store it into the list in MainModel
        NumRestaurant(name: restaurantName, numPicked: numPicked);

    try {
      //adds it to the list
      model.addNumRestaruant(restaruant: numRestaruantModel);
    } catch (e) {}
  }

//update restaurant and returns true or false if it does exist
// required String restaurantName - restaurantName
  //required MainModel model - the main model storing all the data
  bool updateRestaurantPicked(
      {required String restaurantName, required MainModel model}) {
    bool restaurantExist = false;

    try {
      //finds to see if the restaurant exists in the list and then updates the numpicked number
      if (model.getRestaruant(restaurantName: restaurantName)) {
        numPicked = model.updateNumPicked(
            restaurantName: restaurantName); //update the numpicked number
        restaurantExist = true; //restaurant exist is true
      }
    } catch (e) {}
    return restaurantExist;
  }
}
