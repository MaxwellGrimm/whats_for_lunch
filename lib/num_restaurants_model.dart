import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whats_for_lunch/for_lunch.dart';

//this class keeps track of how many times the user has picked a restaurant
class NumRestaruant {
  String? name;
  int? numPicked;
  var db = FirebaseFirestore.instance;

  NumRestaruant({this.name});

  String getName() {
    return name!;
  }

  int getNumPicked() {
    return numPicked!;
  }

//this will add the new restaurant that has never been picked to the document
//returns the database
  Future<void> addRestaurant(
      {required int numPicked, required String restaurantName}) {
    return db
        .collection('NumRestaurantPicked')
        .add({'numPicked': numPicked, 'restaurantName': restaurantName});
  }

  //searches for the resturant and checks to see if it already exist
  //if it does, then update the numpicked and return true,
  //if it doesnt, then return false
  Future<bool> searchQuery({required String restaurantName}) async {
    int numPicked = 0; //number of times it has been picked
    String docID = '';
    bool restaurantExist = false;
    int addOne = 1; //addes one if it has been picked

    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(restaurantName).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      numPicked = data?['numPicked'];
      restaurantExist = true;
    }
    /*FirebaseFirestore.instance
        .collection('NumRestaurantPicked')
        .where('restaurantName', isEqualTo: [restaurantName])
        .get()
        .then((QuerySnapshot querySnapshot) {//its not going in here .. why?
          querySnapshot.docs.forEach((doc) {
            numPicked = doc['numPicked'];
            docID = doc.id;
            restaurantExist = true;
          });
        });*/

    int totalPicked = numPicked + addOne;
//if the restaurant exist then update the numpicked for that specific restaurant
    if (restaurantExist) {
      FirebaseFirestore.instance
          .collection('NumRestaurantPicked')
          .doc(docID)
          .update({'numPicked': totalPicked.toString()});
    }

    return restaurantExist;
  }
}

class NumRestaruantModel extends ChangeNotifier {
  final List<NumRestaruant> _restaruant = [];

  bool addNumRestaruant({required NumRestaruant restaruant}) {
    try {
      _restaruant.add(restaruant);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  NumRestaruant getRestaruant({required int at}) {
    NumRestaruant restaruant = _restaruant[at];
    return restaruant;
  }

  int numResturant() {
    return _restaruant.length;
  }
}
